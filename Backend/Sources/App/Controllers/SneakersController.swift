//
//  SneakersController.swift
//
//
//  Created by Evgeny Serdyukov on 11.05.2022.
//

import Fluent
import Vapor
import Foundation

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}

struct SneakersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let sneakers = routes.grouped("sneakers")
        sneakers.get("all", use: all)
        sneakers.get("portion", ":count", use: portion)
        sneakers.get("portion", use: portion) // With query parameter "id"
        sneakers.get("360", ":id", use: get360)
        sneakers.post("create", use: create)
        sneakers.post("update", use: updateDetailInfo)
        sneakers.group(":sneakerID") { sneaker in
            sneaker.delete(use: delete)
        }
    }

    private func all(req: Request) async throws -> [Sneaker] {
        try await Sneaker.query(on: req.db).all()
    }

    private func portion(req: Request) async throws -> [SneakerDTO] {
        if let count_p = req.parameters.get("count") {
            let count = Int(count_p) ?? 20 // default value
            let sneakers = try await Sneaker.query(on: req.db)
                .filter(\.$detailsDownloaded == true)
                .limit(count)
                .all()
            let result: [SneakerDTO] = try await sneakers.asyncMap { sneaker in
                var item = SneakerDTO(from: sneaker)
                if let id = sneaker.id?.uuidString {
                    req.parameters.set("id", to: id)
                    item.images360 = try await get360(req: req).map(\.image)
                }
                return item
            }
            return result
        } else if let ids_p =  req.query[[String].self, at: "id"] {
            let sneakers = try await Sneaker.query(on: req.db)
                .filter(\.$idStockX ~~ ids_p)
                .all()
            let result: [SneakerDTO] = try await sneakers.asyncMap { sneaker in
                var item = SneakerDTO(from: sneaker)
                if let id = sneaker.id?.uuidString {
                    req.parameters.set("id", to: id)
                    var images360 = try await get360(req: req).map(\.image)

                    if images360.isEmpty {
                        if let data = try await getProductInfoFromStockX(urlKey: sneaker.idStockX) {
                            try await create360(
                                req: req,
                                sneakerID: sneaker.id,
                                images: data.images360
                            )
                            images360 = try await get360(req: req).map(\.image)
                    }
                }
                item.images360 = images360
            }
                return item
            }
            return result
        } else {
            return []
        }
    }

    private func updateDetailInfo(req: Request) async throws -> String {
        let sneakers = try await Sneaker.query(on: req.db)
            .filter(\.$detailsDownloaded == false)
            .all()

        var count = 0

        for index in 0..<sneakers.count {
            var item = SneakerDTO(from: sneakers[index])
            do {
                sleep(1)
                if let data = try await getProductInfoFromStockX(urlKey: sneakers[index].idStockX) {
                    item.detailsDownloaded = true
                    item.brand = data.brand
                    item.condition = data.condition
                    item.countryOfManufacture = data.countryOfManufacture
                    item.primaryCategory = data.primaryCategory
                    item.secondaryCategory = data.secondaryCategory
                    item.releaseDate = data.releaseDate
                    item.year = data.year
                    item.images360 = data.images360
                    item.has360 = data.has360
                    item.resellPricesStockX = data.resellPricesStockX
                    try await handleSneaker(with: item, req: req)
                    count += 1
                } else {
                    return ("Updated \(count) from \(sneakers.count)")
                }
            }
        }
        return ("Updated \(count) from \(sneakers.count)")
    }

    private func get360(req: Request) async throws -> [Sneaker360Presentation] {
        try await Sneaker360Presentation.query(on: req.db)
            .filter(\.$sneakerID == req.parameters.get("id"))
            .all()
    }

    private func create(req: Request) async throws -> HTTPStatus {
        let sneakers = try await getProductData(keyWord: "", count: 10000)
        for i in 0..<sneakers.count {
            try await handleSneaker(with: sneakers[i], req: req)
        }
        return .ok
    }

    private func handleSneaker(with sneakerDTO: SneakerDTO, req: Request) async throws -> Void {
        if let sneaker = try await Sneaker.query(on: req.db)
            .filter(\.$idStockX == sneakerDTO.urlKey)
            .first() {
            //update info in main table
            sneaker.update(with: sneakerDTO)
            try await sneaker.update(on: req.db)
            //Rewrite 360 representation
            try await delete360(req: req, sneakerID: sneaker.id)
            try await create360(req: req, sneakerID: sneaker.id, images: sneakerDTO.images360)
            //Rewrite prices
            try await deleteSizeAndPrices(req: req, sneakerID: sneaker.id)
            try await createSizeAndPrices(req: req, sneakerID: sneaker.id, data: sneakerDTO.resellPricesStockX, shop: Shop.stockX)

        } else {
            let sneaker = Sneaker(sneakerDTO: sneakerDTO)
            try await sneaker.create(on: req.db)
            try await create360(req: req, sneakerID: sneaker.id, images: sneakerDTO.images360)
            try await createSizeAndPrices(req: req, sneakerID: sneaker.id, data: sneakerDTO.resellPricesStockX, shop: Shop.stockX)
        }
    }

    private func delete(req: Request) async throws -> HTTPStatus {
        guard let sneaker = try await Sneaker.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await sneaker.delete(on: req.db)
        return .ok
    }

    private func delete360(req: Request, sneakerID: UUID?) async throws -> Void {
        try await Sneaker360Presentation.query(on: req.db)
            .filter(\.$sneakerID == sneakerID)
            .delete(force: true)
    }

    private func deleteSizeAndPrices(req: Request, sneakerID: UUID?) async throws -> Void {
        try await SneakerSizeAndPrice.query(on: req.db)
            .filter(\.$sneakerID == sneakerID)
            .delete(force: true)
    }

    private func create360(req: Request, sneakerID: UUID?, images: [String]) async throws -> Void {
        if images.count != 0 {
            let jsonData = try JSONEncoder().encode(images)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let item = Sneaker360Presentation(sneakerID: sneakerID, image: jsonString)
            try await item.create(on: req.db)
        }
    }

    private func createSizeAndPrices(req: Request, sneakerID: UUID?, data: [SneakerDTO.ResellPrice], shop: Shop) async throws -> Void {
        if data.count != 0 {
            let jsonData = try JSONEncoder().encode(data)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let item = SneakerSizeAndPrice(sneakerID: sneakerID, shop: shop.rawValue, prices: jsonString)
            try await item.create(on: req.db)
        }
    }
}
