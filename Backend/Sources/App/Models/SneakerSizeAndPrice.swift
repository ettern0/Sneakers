//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 20.05.2022.
//
import Fluent
import Vapor

enum Shop: String, Codable {
    case stockX, stadiumgoods, goat, flightClub
}

final class SneakerSizeAndPrice: Model, Content {
    static let schema = "sneakerSizeAndPrice"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "sneakerID")
    var sneakerID: UUID?

    @Field(key: "shop")
    var shop: String

    @Field(key: "size")
    var size: String

    @Field(key: "price")
    var price: Double

    init() { }

    init(id: UUID?) {
        self.id = (id == nil ? UUID() : id)
    }
}

extension SneakerSizeAndPrice {
    convenience init(id: UUID? = nil, sneakerID: UUID? = nil, shop: String, size: String, price: Double) {
        self.init(id: id)
        self.sneakerID = sneakerID
        self.shop = shop
        self.size = size
        self.price = price
    }

    func update(image: String) {
        self.size = size
        self.price = price
    }
}
