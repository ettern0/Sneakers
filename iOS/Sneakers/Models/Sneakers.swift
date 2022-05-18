//
//  Sneakers.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation
import SwiftUI

struct Sneaker: Identifiable, Codable, Hashable {
    let id: UUID?
    var thumbnail: String
    var description: String
    var shoeName: String
}

final class MapSneakersID {
    static let shared = MapSneakersID()
    var map: [UUID: Int] = [:]
}
