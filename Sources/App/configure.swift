import Vapor
import Fluent
import FluentMySQLDriver


// configures your application
public func configure(_ app: Application) throws {
    let port: Int
   
    if let dbUrlEnv = Environment.get("DATABASE_URL") {
        app.databases.use(try .mysql(url: dbUrlEnv), as: .mysql)
    } else {
        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none
        guard let serverHostname = Environment.get("SERVER_HOSTNAME") else {
            return print("No Env Server Hostname")
        }
        if let envPort = Environment.get("SERVER_PORT") {
            port = Int(envPort) ?? 8081
        } else {
            port = 8081
        }
        app.databases.use(.mysql(
            hostname: Environment.get("DB_HOSTNAME")!,
            port: Environment.get("DB_PORT").flatMap(Int.init(_:))!,
            username: Environment.get("DB_USERNAME")!,
            password: Environment.get("DB_PASSWORD")!,
            database: Environment.get("DB_NAME")!,
            tlsConfiguration: tls
            ), as: .mysql)
        app.http.server.configuration.hostname = serverHostname
        app.http.server.configuration.port = port
    }


    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)

    // Only add this if you want to enable the default per-route logging
    let routeLogging = RouteLoggingMiddleware(logLevel: .info)

    // Add the default error middleware
    let error = ErrorMiddleware.default(environment: app.environment)
    // Clear any existing middleware.
    app.middleware = .init()
    app.middleware.use(cors)
    app.middleware.use(routeLogging)
    app.middleware.use(error)

    app.migrations.add(
        CreateSchemaProduct() , to: .mysql
    )
    app.logger.logLevel = .debug
    

    // migration db
    try app.autoMigrate().wait()

    // print("CONFIG", app.databases)
    

    // register routes
    try routes(app)
}
