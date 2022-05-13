//
//  CreateSneaker360Presentation.swift
//  
//
//  Created by Evgeny Serdyukov on 13.05.2022.
//

import Fluent

struct CreateSneaker360Presentation: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("sneakers360Presentation")
            .id()
            .field("sneakerID", .uuid, .required)
            .field("image", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("sneakers360Presentation").delete()
    }
}
