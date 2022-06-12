//
//  FiltersResponse.swift
//  
//
//  Created by Alexey Salangin on 13.06.2022.
//

import Foundation

public struct FiltersResponse: Codable {
    public let filters: Filters
    public let palettes: [ColorPalette]

    public init(filters: Filters, palettes: [ColorPalette]) {
        self.filters = filters
        self.palettes = palettes
    }
}
