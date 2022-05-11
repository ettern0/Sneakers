import Fluent

struct CreateSneaker: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("sneakers")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("sneakers").delete()
    }
}
