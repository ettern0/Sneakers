import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    //try app.databases.use(.postgres(url: Environment.databaseURL), as: .psql)
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
    app.logger.logLevel = .debug

    if app.environment == .development {
        try app.autoMigrate().wait()
    }

    // register routes
    try routes(app)
}
