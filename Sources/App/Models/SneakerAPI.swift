//
//  File.swift
//
//
//  Created by Evgeny Serdyukov on 28.04.2022.
//

import Foundation

struct SneakerAPI: Codable {
    var shoeName: String
    var brand: String
    var silhoutte: String
    var styleID: String
    var retailPrice: Double
    var releaseDate: String
    var description: String
    var imageLinks: [String] = []
    var thumbnail: String
    var urlKey: URL
    var make: String
    var goatProductId: Int = 0
    var colorway: String
    var size: Double = 0.0

    var resellLinkStockX: String = ""
    var resellLinkStadiumGoods: String = ""
    var resellLinkGoat: String = ""
    var resellLinkFlightClub: String = ""

    var lowestResellPriceStockX: String = ""
    var lowestResellPriceStadiumGoods: String = ""
    var lowestResellPriceGoat: String = ""
    var lowestResellPriceFlightClub: String = ""

    var resellPricesStockX: [ResellPrice] = []
    var resellPricesStadiumGoods: [ResellPrice] = []
    var resellPricesGoat: [ResellPrice] = []
    var resellPricesFlightClub: [ResellPrice] = []

    struct ResellPrice: Codable {
        var size: String
        var price: Double
    }
}

struct ResponseFromSecondaryAPI {
    var resellLink = ""
    var lowestResellPrice = ""
    var resellPrices: [SneakerAPI.ResellPrice] = []
    var goatProductId: Int = 0
}
