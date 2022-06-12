//
//  ColorPaletteGenerator.swift
//  
//
//  Created by Alexey Salangin on 12.06.2022.
//

import Foundation
import SneakerModels

enum ColorPaletteGenerator {
    static func palettes(from colors: [UInt32]) -> [ColorPalette] {
        return [ColorPalette(sourceColors: colors, suggestedColors: colors)]
    }
}
