//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 20.05.2022.
//

import Fluent

struct CreateSneakerSizeAndPrice: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("sneakerSizeAndPrice")
            .id()
            .field("sneakerID", .uuid, .required)
            .field("shop", .string, .required)
            .field("prices", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("sneakerSizeAndPrice").delete()
    }
}

