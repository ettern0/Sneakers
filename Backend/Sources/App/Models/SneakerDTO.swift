//
//  SneakerDTO.swift
//
//
//  Created by Evgeny Serdyukov on 28.04.2022.
//

import Foundation
import Vapor

struct SneakerDTO: Codable {
    internal init(shoeName: String = "", brand: String = "", silhoutte: String = "", styleID: String = "", retailPrice: Double = 0.0, releaseDate: String = "", description: String = "", imageLinks: [String] = [], thumbnail: String = "", urlKey: String = "", make: String = "", goatProductId: Int = 0, colorway: String = "", size: Double = 0.0, condition: String = "", countryOfManufacture: String = "", primaryCategory: String = "", secondaryCategory: String = "", year: String = "", resellLinkStockX: String = "", resellLinkStadiumGoods: String = "", resellLinkGoat: String = "", resellLinkFlightClub: String = "", lowestResellPriceStockX: String = "", lowestResellPriceStadiumGoods: String = "", lowestResellPriceGoat: String = "", lowestResellPriceFlightClub: String = "", resellPricesStockX: [SneakerDTO.ResellPrice] = [], resellPricesStadiumGoods: [SneakerDTO.ResellPrice] = [], resellPricesGoat: [SneakerDTO.ResellPrice] = [], resellPricesFlightClub: [SneakerDTO.ResellPrice] = [], images360: [String] = []) {
        self.shoeName = shoeName
        self.brand = brand
        self.silhoutte = silhoutte
        self.styleID = styleID
        self.retailPrice = retailPrice
        self.releaseDate = releaseDate
        self.description = description
        self.imageLinks = imageLinks
        self.thumbnail = thumbnail
        self.urlKey = urlKey
        self.make = make
        self.goatProductId = goatProductId
        self.colorway = colorway
        self.size = size
        self.condition = condition
        self.countryOfManufacture = countryOfManufacture
        self.primaryCategory = primaryCategory
        self.secondaryCategory = secondaryCategory
        self.year = year
        self.resellLinkStockX = resellLinkStockX
        self.resellLinkStadiumGoods = resellLinkStadiumGoods
        self.resellLinkGoat = resellLinkGoat
        self.resellLinkFlightClub = resellLinkFlightClub
        self.lowestResellPriceStockX = lowestResellPriceStockX
        self.lowestResellPriceStadiumGoods = lowestResellPriceStadiumGoods
        self.lowestResellPriceGoat = lowestResellPriceGoat
        self.lowestResellPriceFlightClub = lowestResellPriceFlightClub
        self.resellPricesStockX = resellPricesStockX
        self.resellPricesStadiumGoods = resellPricesStadiumGoods
        self.resellPricesGoat = resellPricesGoat
        self.resellPricesFlightClub = resellPricesFlightClub
        self.images360 = images360
    }
    
    var shoeName: String = ""
    var brand: String = ""
    var silhoutte: String = ""
    var styleID: String = ""
    var retailPrice: Double = 0.0
    var releaseDate: String = ""
    var description: String = ""
    var imageLinks: [String] = []
    var thumbnail: String = ""
    var urlKey: String = ""
    var make: String = ""
    var goatProductId: Int = 0
    var colorway: String = ""
    var size: Double = 0.0

    var condition: String = ""
    var countryOfManufacture: String = ""
    var primaryCategory: String = ""
    var secondaryCategory: String = ""
    var year: String = ""

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

    var images360: [String] = []

    init(from sneaker: Sneaker) {

        self.shoeName = sneaker.shoeName
        self.brand = sneaker.brand
        self.styleID = sneaker.styleID
        self.releaseDate = sneaker.releaseDate
        self.description = sneaker.description
        self.thumbnail = sneaker.thumbnail
        self.urlKey = sneaker.idStockX
        self.colorway = sneaker.colorway
        self.condition = sneaker.condition
        self.countryOfManufacture = sneaker.countryOfManufacture
        self.primaryCategory = sneaker.primaryCategory
        self.secondaryCategory = sneaker.secondaryCategory
        self.year = sneaker.year
    }
}

struct ResponseFromSecondaryAPI {
    var resellLink = ""
    var lowestResellPrice = ""
    var resellPrices: [SneakerDTO.ResellPrice] = []
    var goatProductId: Int = 0
}

extension SneakerDTO: Content {
    
}
