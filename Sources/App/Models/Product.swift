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
    
    @Field(key: "varian_id")
    var varian_id: UUID?
    
    @Field(key: "topping_id")
    var topping_id: UUID?
    
    @Field(key: "image_gallery_id")
    var image_gallery_id: UUID?
    
    init() {}
    
    init(id: UUID? = nil, name: String, description:String, price: Int, image_featured: String, sku: String, stock: Float, category_id: UUID, varian_id: UUID, topping_id: UUID, image_gallery_id: UUID) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.image_featured = image_featured
        self.sku = sku
        self.stock = stock
        self.category_id = category_id
        self.varian_id = varian_id
        self.topping_id = topping_id
        self.image_gallery_id = image_gallery_id
        
    }
}

extension Product: Content{}

final class UpdateCategoryID: Content, Codable {
    var category_id: UUID
    
    init(category_id: UUID) {
        self.category_id = category_id
    }
}
