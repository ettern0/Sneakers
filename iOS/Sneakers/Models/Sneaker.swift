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

    private enum CodingKeys: String, CodingKey {
        case id = "urlKey"
        case thumbnail
        case description
        case name = "shoeName"
        case brand
        case has360
        case images360
    }
}
