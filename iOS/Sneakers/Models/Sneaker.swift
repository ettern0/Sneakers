//
//  Sneakers.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation
import SwiftUI

struct Sneaker: Identifiable, Codable, Hashable {

    let id: String
    let thumbnail: String
    let description: String
    let name: String
    let brand: String
    let has360: Bool
    let images360: [String]
    let resellLinkStockX: String
    let resellLinkStadiumGoods: String
    let resellLinkGoat: String
    let resellLinkFlightClub: String
    let resellPricesStockX: [ResellPrice]

    struct ResellPrice: Codable, Hashable {
        let size: String
        let price: Double
    }

    private enum CodingKeys: String, CodingKey {
        case id = "urlKey"
        case thumbnail
        case description
        case name = "shoeName"
        case brand
        case has360
        case images360
        case resellLinkStockX
        case resellLinkStadiumGoods
        case resellLinkGoat
        case resellLinkFlightClub
        case resellPricesStockX
    }
}

extension Sneaker {
    var minPrice: Double? {
        self.resellPricesStockX.map(\.price).min()
    }

    var maxPrice: Double? {
        self.resellPricesStockX.map(\.price).max()
    }
}
