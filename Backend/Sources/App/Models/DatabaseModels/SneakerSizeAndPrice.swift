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

    @Field(key: "prices")
    var prices: String

    init() { }

    init(id: UUID?) {
        self.id = (id == nil ? UUID() : id)
    }
}

extension SneakerSizeAndPrice {
    convenience init(id: UUID? = nil, sneakerID: UUID? = nil, shop: String, prices: String) {
        self.init(id: id)
        self.sneakerID = sneakerID
        self.shop = shop
        self.prices = prices
    }

    func update(prices: String) {
        self.prices = prices
    }
}
