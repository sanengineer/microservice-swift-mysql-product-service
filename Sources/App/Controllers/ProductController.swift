import Vapor
import Fluent

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let productRouteGroup = routes.grouped("todos")
        let authProductRouteGroup = productRouteGroup.grouped(UserAuthMiddleware())
        
        productRouteGroup.get(use: readAllHandler)
        productRouteGroup.get("result", use: searchHandler)
        productRouteGroup.get("count", use: countHandler)
        productRouteGroup.get("category", ":category_id", use: searchByCategoryId)
        productRouteGroup.group(":product_id") { product in
            product.get(use: readOneHandler)
            product.put("category", use: updateCategoryId)
        }
        
        authProductRouteGroup.post(use: createHandler)
        authProductRouteGroup.group(":product_id") { product in
            product.put(use: updateHandler)
            product.delete(use: deleteHandler)
        }
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Product> {
        let product = try req.content.decode(Product.self)
        return product.save(on: req.db).map{product}
    }

    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Product> {
        let updateProduct = try req.content.decode(Product.self)

        return Product.find(req.parameters.get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.description = updateProduct.description
                product.name = updateProduct.name
                product.price = updateProduct.price
                product.image_featured = updateProduct.image_featured
                
                return product.save(on: req.db).map{product}
            }
    }
    
    func updateCategoryId(_ req: Request) throws -> EventLoopFuture<Product> {
        let updateProduct = try req.content.decode(UpdateCategoryID.self)
        
        return Product.find(req.parameters.get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.category_id = updateProduct.category_id
                
                return product.save(on: req.db).map{product}
            }
    }
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus>  {
        Product.find(req.parameters.get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    func readAllHandler(_ req: Request) throws -> EventLoopFuture<[Product]> {
        Product.query(on: req.db).sort(\.$name, .ascending).all()
    }
    
    func readOneHandler(_ req: Request) throws -> EventLoopFuture<Product>  {
        Product.find(req.parameters.get("product_id"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func searchByCategoryId(_ req: Request) throws -> EventLoopFuture<[Product]> {
        let category_id = req.parameters.get("category_id", as: UUID.self)
        
        return Product
            .query(on: req.db)
            .filter(\.$category_id == category_id)
            .all()
    }
    
    func searchHandler(_ req: Request) throws -> EventLoopFuture<[Product]> {
        guard let searchQuery = req.query[String.self, at: "search_query"] else { throw
            Abort(.badRequest)
        }
        
        return Product.query(on: req.db)
            .filter(\.$name ~~ searchQuery)
            .all()
    }
    
    func countHandler(_ req: Request) throws -> EventLoopFuture<Int> {
        Product.query(on: req.db).count()
    }
}
