//
//  configure.swift
//
//
//  Created by Evgeny Serdyukov on 28.04.2022.
//

import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    if var postgresConfig = PostgresConfiguration(url: Environment.databaseURL) {
        postgresConfig.tlsConfiguration = .makeClientConfiguration()
        postgresConfig.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    } else {
        fatalError("DATABASE_URL not configured")
    }

    app.migrations.add(CreateSneaker())
    app.migrations.add(CreateSneaker360Presentation())
    app.migrations.add(CreateSneakerSizeAndPrice())
    app.migrations.add(CreateSneakerColorway())
    app.logger.logLevel = .debug

    if app.environment == .development {
        try app.autoMigrate().wait()
    }

    // register routes
    try routes(app)
}
