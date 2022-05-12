import Fluent

struct CreateSneaker: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("sneakers")
            .id()
            .field("idStockX", .string, .required)
            .field("styleID", .string, .required)
            .field("thumbnail", .string, .required)
            .field("colorway", .string, .required)
            .field("shoeName", .string, .required)
            .field("description", .string, .required)
            .create()
        try await database.schema("sneakers360Presentation")
            .id()
            .field("sneakerID", .uuid, .required)
            .field("image", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("sneakers").delete()
        try await database.schema("sneakers360Presentation").delete()
    }
}
