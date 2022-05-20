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
    var description: String
    var shoeName: String

    private enum CodingKeys: String, CodingKey {
        case id = "urlKey"
        case thumbnail
        case description
        case shoeName
    }
}
