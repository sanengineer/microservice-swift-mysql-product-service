import Fluent
import Vapor

func routes(_ app: Application) throws {
    // app.get { req in
    //     return "Hello To Product API Services"
    // }

    app.get("hello") { req -> String in
        return "Hello To Product API Services"
    }
    
    try app.register(collection: ProductController() )
}
