//
//  CreateSneakers.swift
//
//
//  Created by Evgeny Serdyukov on 13.05.2022.
//

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
    }

    func revert(on database: Database) async throws {
        try await database.schema("sneakers").delete()
    }
}
