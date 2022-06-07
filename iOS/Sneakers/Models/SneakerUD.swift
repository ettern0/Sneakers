//
//  SneakerUD.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 27.05.2022.
//

import Foundation

struct SneakerUD: Codable, Identifiable {

    let id: String
    let thumbnail: String
    let brand: String
    let name: String

    init(from sneaker: Sneaker) {
        self.id = sneaker.id
        self.thumbnail = sneaker.thumbnail
        self.brand = sneaker.brand
        self.name = sneaker.name
    }
}
