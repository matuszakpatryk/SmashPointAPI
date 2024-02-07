import Vapor
import JWT
import Fluent
import FluentMySQLDriver

// configures your application
public func configure(_ app: Application) async throws {
    
    app.logger.info("Environment: \(app.environment.name)")
    app.logger.info("Log level: \(app.logger.logLevel)")

    // middlewares

    app.middleware.use(
        FileMiddleware(
            publicDirectory: app.directory.publicDirectory,
            defaultFile: "index.html"
        )
    )
    
    // MARK: JWT
    app.jwt.signers.use(.hs256(key: "SecretKeyForJWT"))
    
    // MARK: Database
    //TODO: Fix before release
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    
    app.databases.use(
        .mysql(
            hostname: "localhost",
            username: "root",
            password: "qwertyuiop12",
            database: "smashpoint",
            tlsConfiguration: tls),
        as: .mysql)

    try routes(app)
    try migrations(app)
    try services(app)
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    ContentConfiguration.global.use(encoder: encoder, for: .json)
}
