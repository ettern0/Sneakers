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

    func create(req: Request) async throws -> Sneaker {
        let sneaker = try req.content.decode(Sneaker.self)
        try await sneaker.save(on: req.db)
        return sneaker
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let sneaker = try await Sneaker.find(req.parameters.get("sneakerID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await sneaker.delete(on: req.db)
        return .ok
    }
}
