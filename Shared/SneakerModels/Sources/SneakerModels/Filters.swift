//
//  Filters.swift
//  
//
//  Created by Alexey Salangin on 13.06.2022.
//

import Foundation

public struct Filters: Codable {
    public let minPrice: Double
    public let maxPrice: Double
    public let sizes: [String]
    public let brands: [String]
    public let gender: [Int]

    public init(
        minPrice: Double = 0.0,
        maxPrice: Double = 0.0,
        sizes: [String] = [],
        brands: [String] = [],
        gender: [Int] = []
    ) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.sizes = sizes
        self.brands = brands
        self.gender = gender
    }
}
