//
//  SneakersController.swift
//
//
//  Created by Evgeny Serdyukov on 11.05.2022.
//

import Fluent
import Vapor

struct SneakersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let sneakers = routes.grouped("sneakers")
        sneakers.get("all", use: all)
        sneakers.get("portion", use: portion)
        sneakers.post("create", use: create)
        sneakers.group(":sneakerID") { sneaker in
            sneaker.delete(use: delete)
        }
    }

    private func all(req: Request) async throws -> [Sneaker] {
        try await Sneaker.query(on: req.db).all()
    }

    private func portion(req: Request) async throws -> [Sneaker] {
        try await Sneaker.query(on: req.db).limit(20).all()
    }

    private func create(req: Request) async throws -> HTTPStatus {
        var count = 100
        var page = 1
        while count > 0 {
            let sneakers = try await getProductData(keyWord: "", page: page, count: 100)
            for i in 0..<sneakers.count {
                try await handleSneaker(with: sneakers[i], req: req)
            }
            count = sneakers.count
            page += 1
        }
        return .ok
    }

    private func handleSneaker(with sneakerDTO: SneakerDTO, req: Request) async throws -> Void {
        if let sneaker = try await Sneaker.query(on: req.db)
            .filter(\.$idStockX == sneakerDTO.urlKey)
            .first() {

            //update info in main table
            sneaker.update(with: sneakerDTO)
            //Rewrite 360 representation
            try await delete360(req: req, id: sneaker.id)
            try await create360(req: req, sneakerID: sneaker.id, images: sneakerDTO.images360)

            for i in 0..<sneakerDTO.images360.count {
                let image = sneakerDTO.images360[i]
                let sneaker360 = Sneaker360Presentation(sneakerID: sneaker.id, image: image)
                try await sneaker360.create(on: req.db)
            }

        } else {
            let sneaker = Sneaker(sneakerDTO: sneakerDTO)

            //create sneakers main table
            try await sneaker.create(on: req.db)
            //create 360 represenation
            try await create360(req: req, sneakerID: sneaker.id, images: sneakerDTO.images360)

        }
    }

    private func delete(req: Request) async throws -> HTTPStatus {
        guard let sneaker = try await Sneaker.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await sneaker.delete(on: req.db)
        return .ok
    }

    private func delete360(req: Request, id: UUID?) async throws -> Void {
        try await Sneaker360Presentation.query(on: req.db)
            .filter(\.$sneakerID == id)
            .delete(force: true)
    }

    private func create360(req: Request, sneakerID: UUID?, images: [String]) async throws -> Void {
        for i in 0..<images.count {
            let image = images[i]
            let sneaker360 = Sneaker360Presentation(sneakerID: sneakerID, image: image)
            try await sneaker360.create(on: req.db)
        }
    }
}
