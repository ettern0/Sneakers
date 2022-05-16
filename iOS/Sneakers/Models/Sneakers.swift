//
//  Sneakers.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation

struct Sneaker: Identifiable, Codable {
    let id: UUID?
    var thumbnail: String
    var description: String
    var shoeName: String
}
