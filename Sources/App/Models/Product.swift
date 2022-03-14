//
//  Product.swift
//  
//
//  Created by San Engineer on 11/01/22.
//

import Vapor
import Fluent

final class Product: Model {
    static let schema = "products"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "price")
    var price: Int
    
    @Field(key: "image_featured")
    var image_featured: String
    
    @Field(key: "sku")
    var sku : String?
    
    @Field(key: "stock")
    var stock: Float?
    
    @Field(key: "category_id")
    var category_id : UUID?
    
    @Field(key: "image_gallery_id")
    var image_gallery_id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() {}
    
    init(id: UUID? = nil, name: String, description:String, price: Int, image_featured: String, sku: String, stock: Float, category_id: UUID, image_gallery_id: UUID, created_at: Date?, updated_at: Date?) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.image_featured = image_featured
        self.sku = sku
        self.stock = stock
        self.category_id = category_id
        self.image_gallery_id = image_gallery_id
        self.created_at = created_at
        self.updated_at = updated_at
    }
}

extension Product: Content{}


final class ProductUpdate: Content, Codable {
    var name: String?
    var description: String?
    var price: Int?
    var image_featured: String?
    var sku: String?
    var stock: Float?
    var category_id: UUID?
    var image_gallery_id: UUID?

    init(name: String?, description: String?, price: Int?, image_featured: String?, sku: String?, stock: Float?, category_id: UUID?, image_gallery_id: UUID?) {
        self.name = name
        self.description = description
        self.price = price
        self.image_featured = image_featured
        self.sku = sku
        self.stock = stock
        self.category_id = category_id
        self.image_gallery_id = image_gallery_id
    }
}

final class UpdateCategoryID: Content, Codable {
    var category_id: UUID
    
    init(category_id: UUID) {
        self.category_id = category_id
    }
}
