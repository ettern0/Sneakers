import Fluent
import Vapor

struct SneakersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let sneakers = routes.grouped("sneakers")
        sneakers.get(use: index)
        sneakers.post(use: create)
        sneakers.group(":sneakerID") { sneaker in
            sneaker.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Sneaker] {
        try await Sneaker.query(on: req.db).all()
    }

    func create(req: Request) async throws -> HTTPStatus {
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

            //TODO update 360 represenation
        } else {
            let sneaker = Sneaker(sneakerDTO: sneakerDTO)

            //create sneakers main table
            try await sneaker.create(on: req.db)

            //create 360 represenation
            for i in 0..<sneakerDTO.images360.count - 1 {
                let image = sneakerDTO.images360[i]
                let sneaker360 = Sneaker360Presentation(sneakerID: sneaker.id, image: image)
                try await sneaker360.create(on: req.db)
            }

        }
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let sneaker = try await Sneaker.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await sneaker.delete(on: req.db)
        return .ok
    }
}
