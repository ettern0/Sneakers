//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 09.06.2022.
//

import Foundation

struct Filter: Codable {
    var minPrice: Double = 0.0
    var maxPrice: Double = 0.0
    var sizes: [String] = []
    var brands: [String] = []
    var gender: [String] = []
}
