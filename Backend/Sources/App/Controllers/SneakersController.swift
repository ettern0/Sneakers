//
//  SneakersController.swift
//
//
//  Created by Evgeny Serdyukov on 11.05.2022.
//

import Fluent
import Vapor
import Foundation
import SneakerModels
import ColorsMatcher

struct SneakersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let sneakers = routes.grouped("sneakers")
        sneakers.get("all", use: all)
        sneakers.get("filters", ":palette", use: filters)
        sneakers.get("portion", ":count", use: portion)
        sneakers.get("360", ":id", use: get360)
        sneakers.get("portion", use: portion) // With query parameter "id"
        sneakers.get("sneakersWithUserFilters", use: sneakersWithUserFilters)
        sneakers.post("create", use: create)
        sneakers.post("update", use: updateDetailInfo)
        sneakers.post("fillColors", use: fillColors)
        sneakers.get("colors", use: allColors)
        sneakers.get("colorsForName", use: colorsForName)
        sneakers.group(":sneakerID") { sneaker in
            sneaker.delete(use: delete)
        }
    }

    private func all(req: Request) async throws -> [Sneaker] {
        try await Sneaker.query(on: req.db).all()
    }

    private func sneakersWithUserFilters(req: Request) async throws -> [SneakerDTO] {

        var respond: [SneakerDTO] = []

        do {
            let userFilters = try req.content.decode(UserFitersRequestData.self).userFilters

            var idsColor: [UUID] = []
            let colors = try await SneakerColorway.query(on: req.db).all()
            colors.forEach { value in
                if let id = value.sneakerID, let intColor = color(from: value.color), userFilters.colors.contains(intColor) {
                    idsColor.append(id)
                }
            }

            //Get a sneakers from color
            // MARK: TODO sneakers from other filters
            let sneakers = try await Sneaker.query(on: req.db)
                .filter(\.$id ~~ idsColor)
                .all()
            respond = try await sneakers.asyncMap { sneaker in
                var item = SneakerDTO(from: sneaker)
                if let id = sneaker.id?.uuidString {
                    req.parameters.set("id", to: id)
                    item.images360 = try await get360(req: req).map(\.image)
                }
                return item
            }

        } catch {
            return []
        }
        return respond
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

    func get360(req: Request) async throws -> [Sneaker360Presentation] {
        try await Sneaker360Presentation.query(on: req.db)
            .filter(\.$sneakerID == req.parameters.get("id"))
            .all()
    }

    private func fillColors(req: Request) async throws -> String {
        let sneakers = try await Sneaker.query(on: req.db).all()
        sneakers.forEach { sneaker in
            let colors = sneaker.colorway.components(separatedBy: "/")
            colors.forEach { color in
                let item = SneakerColorway(sneakerID: sneaker.id, color: color)
                try? item.create(on: req.db).wait()
            }
        }
        return "ok"
    }

    private func allColors(req: Request) async throws -> String {
        let allColors = try SneakerColorway.query(on: req.db).all().wait()
        let jsonData = try JSONEncoder().encode(allColors)
        return String(decoding: jsonData, as: UTF8.self)
    }

    private func colorsForName(req: Request) throws -> String {
        guard let colorName = req.query[String.self, at: "name"] else { throw Abort(.badRequest) }
        let colors = ColorsMatcher.colors(for: colorName)
        let jsonData = try JSONEncoder().encode(colors)
        return String(decoding: jsonData, as: UTF8.self)
    }

    private func filters(req: Request) async throws -> String {
        guard let colors =  req.query[[UInt32].self, at: "palette"] else { throw Abort(.badRequest) }
        guard let palettes = ColorPaletteGenerator.palettes(from: colors) else { throw Abort(.internalServerError) }

        //MARK: TODO get the colors in some way from UI
        var ids: [UUID] = []
        var brands: Set<String> = []
        var prices: Set<Double> = []
        var sizes: Set<String> = []
        let genders: Set<Int> = [0, 1] //MARK: TODO Genders

        let stringColors = ["white", "black"] // TODO:
        let sneakers = try await SneakerColorway.query(on: req.db)
            .filter(\.$color ~~ stringColors)
            .all()
        sneakers.forEach { value in
            if let id = value.sneakerID {
                ids.append(UUID(uuidString: id.uuidString) ?? UUID())
            }
        }

        let details = try await Sneaker.query(on: req.db)
            .filter(\.$id ~~ ids)
            .all()

        details.forEach { value in
            brands.insert(value.brand)
        }

        let sizeAndPrices = try await SneakerSizeAndPrice.query(on: req.db)
            .filter(\.$sneakerID ~~ ids)
            .all()

        sizeAndPrices.forEach { value in
            var data: [SneakerDTO.ResellPrice] = []
            let jsonData = Data(value.prices.utf8)
            let jsonDecoder = JSONDecoder()
            do {
                data = try jsonDecoder.decode([SneakerDTO.ResellPrice].self, from: jsonData)
                data.forEach { value in
                    prices.insert(value.price)
                    sizes.insert(value.size.replacingOccurrences(of: "W", with: ""))
                }
            } catch { assertionFailure(error.localizedDescription) }
        }

        let filters = Filters(
            minPrice: prices.min() ?? 0,
            maxPrice: prices.max() ?? 0,
            sizes: Array(sizes),
            brands: Array(brands),
            gender: Array(genders)
        )

        let filtersResponse = FiltersResponse(filters: filters, palettes: palettes)

        let jsonEncoder = JSONEncoder()
        do {
            let jsonResultData = try jsonEncoder.encode(filtersResponse)
            return String(decoding: jsonResultData, as: UTF8.self)
        } catch {
            throw Abort(.internalServerError)
        }
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
