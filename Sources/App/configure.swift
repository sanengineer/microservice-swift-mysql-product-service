import Vapor
import Fluent
import FluentMySQLDriver


// configures your application
public func configure(_ app: Application) throws {
    let port: Int
    
    guard let serverHostname = Environment.get("PRODUCT_HOSTNAME") else {
        return print("No Env Server Hostname")
    }

    if let envPort = Environment.get("PRODUCT_PORT"){
        port = Int(envPort) ?? 8081
    } else {
        port = 8081
    }

    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none


    // switch app.environment {
    //     case .production:
    //         app.database.use(.mysql(url:"DATABASE_URL"))
    //     default:
            app.databases.use(.mysql(
                hostname: Environment.get("DB_HOSTNAME")!,
                port: Environment.get("DB_PORT").flatMap(Int.init(_:))!,
                username: Environment.get("DB_USERNAME")!,
                password: Environment.get("DB_PASSWORD")!,
                database: Environment.get("DB_NAME")!,
                tlsConfiguration: tls
            ), as: .mysql)
    // }

    app.migrations.add(
        CreateSchemaProduct() , to: .mysql
    )
    app.logger.logLevel = .debug
    app.http.server.configuration.hostname = serverHostname
    app.http.server.configuration.port = port

    // migration db
    try app.autoMigrate().wait()

    // print("CONFIG", app.databases)
    

    // register routes
    try routes(app)
}
