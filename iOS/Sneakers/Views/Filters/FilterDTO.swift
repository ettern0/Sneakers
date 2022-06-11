//
//  FilterDTO.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 10.06.2022.
//

import Foundation

struct FilterDTO: Codable {
    var minPrice: Double = 0.0
    var maxPrice: Double = 0.0
    var sizes: [String] = []
    var brands: [String] = []
    var gender: [Int] = []
}
