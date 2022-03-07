import Fluent

struct CreateSchemaProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .id()
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("price", .int, .required)
            .field("image_featured", .string, .required)
            .field("sku", .string)
            .field("stock", .int  )
            .field("user_id", .uuid)
            .field("category_id", .uuid )
            .field("varian_id", .uuid )
            .field("topping_id", .uuid )
            .field("image_gallery_id", .uuid)
            .unique(on: "sku")
            .unique(on: "image_gallery_id")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}
