//
//  ColorPalette.swift
//  
//
//  Created by Alexey Salangin on 12.06.2022.
//

import Foundation

public struct ColorPalette: Codable {
    public let sourceColors: [UInt32]
    public let suggestedColors: [UInt32]

    public var allColors: [UInt32] {
        sourceColors + suggestedColors
    }

    public init(sourceColors: [UInt32], suggestedColors: [UInt32]) {
        self.sourceColors = sourceColors
        self.suggestedColors = suggestedColors
    }
}
