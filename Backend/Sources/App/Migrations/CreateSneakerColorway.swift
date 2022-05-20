//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 20.05.2022.
//

import Fluent

struct CreateSneakerColorway: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("sneakerColorway")
            .id()
            .field("sneakerID", .uuid, .required)
            .field("color", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("sneakerColorway").delete()
    }
}


