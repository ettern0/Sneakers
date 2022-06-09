//
//  Sneaker.swift
//
//
//  Created by Evgeny Serdyukov on 12.05.2022.
//

import Fluent
import Vapor

final class Sneaker: Model, Content {
    static let schema = "sneakers"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "idStockX")
    var idStockX: String

    @Field(key: "styleID")
    var styleID: String

    @Field(key: "thumbnail")
    var thumbnail: String

    @Field(key: "colorway")
    var colorway: String

    @Field(key: "shoeName")
    var shoeName: String

    @Field(key: "description")
    var description: String

    @Field(key: "brand")
    var brand: String

    @Field(key: "condition")
    var condition: String

    @Field(key: "countryOfManufacture")
    var countryOfManufacture: String

    @Field(key: "primaryCategory")
    var primaryCategory: String

    @Field(key: "secondaryCategory")
    var secondaryCategory: String

    @Field(key: "releaseDate")
    var releaseDate: String

    @Field(key: "year")
    var year: String

    @Field(key: "resellLinkStockX")
    var resellLinkStockX: String

    @Field(key: "resellLinkStadiumGoods")
    var resellLinkStadiumGoods: String

    @Field(key: "resellLinkGoat")
    var resellLinkGoat: String

    @Field(key: "resellLinkFlightClub")
    var resellLinkFlightClub: String

    @Field(key: "has360")
    var has360: Bool

    @Field(key: "detailsDownloaded")
    var detailsDownloaded: Bool

    init() { }

    init(id: UUID?) {
        self.id = (id == nil ? UUID() : id)
    }
}

extension Sneaker {
    convenience init(id: UUID? = nil, sneakerDTO: SneakerDTO) {
        self.init(id: id)
        self.idStockX = sneakerDTO.urlKey
        self.styleID = sneakerDTO.styleID
        self.thumbnail = sneakerDTO.thumbnail
        self.colorway = sneakerDTO.colorway
        self.shoeName = sneakerDTO.shoeName
        self.description = sneakerDTO.description
        self.brand = sneakerDTO.brand
        self.condition = sneakerDTO.condition
        self.countryOfManufacture = sneakerDTO.countryOfManufacture
        self.primaryCategory = sneakerDTO.primaryCategory
        self.secondaryCategory = sneakerDTO.secondaryCategory
        self.releaseDate = sneakerDTO.releaseDate
        self.year = sneakerDTO.year
        self.resellLinkStockX = sneakerDTO.resellLinkStockX
        self.resellLinkStadiumGoods = sneakerDTO.resellLinkStadiumGoods
        self.resellLinkGoat = sneakerDTO.resellLinkGoat
        self.resellLinkFlightClub = sneakerDTO.resellLinkFlightClub
        self.has360 = sneakerDTO.has360
        self.detailsDownloaded = sneakerDTO.detailsDownloaded
    }

    func update(with sneakerDTO: SneakerDTO) {
        self.idStockX = sneakerDTO.urlKey
        self.styleID = sneakerDTO.styleID
        self.thumbnail = sneakerDTO.thumbnail
        self.colorway = sneakerDTO.colorway
        self.shoeName = sneakerDTO.shoeName
        self.description = sneakerDTO.description
        self.brand = sneakerDTO.brand
        self.condition = sneakerDTO.condition
        self.countryOfManufacture = sneakerDTO.countryOfManufacture
        self.primaryCategory = sneakerDTO.primaryCategory
        self.secondaryCategory = sneakerDTO.secondaryCategory
        self.releaseDate = sneakerDTO.releaseDate
        self.year = sneakerDTO.year
        self.resellLinkStockX = sneakerDTO.resellLinkStockX
        self.resellLinkStadiumGoods = sneakerDTO.resellLinkStadiumGoods
        self.resellLinkGoat = sneakerDTO.resellLinkGoat
        self.resellLinkFlightClub = sneakerDTO.resellLinkFlightClub
        self.detailsDownloaded = sneakerDTO.detailsDownloaded
        self.has360 = sneakerDTO.has360
    }
}
