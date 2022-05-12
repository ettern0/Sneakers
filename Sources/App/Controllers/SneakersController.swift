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
        var count = 1000
        var page = 1
        while count >= 1000 {
            let sneakers = try await getDataFromStockX(keyWord: "", page: page, count: 1000)
            for i in 0..<sneakers.count {
                let sneaker = Sneaker(id: sneakers[i].urlKey.absoluteString)
                try await sneaker.create(on: req.db)
            }
            count = sneakers.count
            page += 1
        }
        return .ok
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let sneaker = try await Sneaker.find(req.parameters.get("sneakerID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await sneaker.delete(on: req.db)
        return .ok
    }
}
