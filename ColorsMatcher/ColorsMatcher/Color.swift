//
//  Color.swift
//  ColorsMatcher
//
//  Created by Alexey Salangin on 13.06.2022.
//

import Foundation

struct Color: Decodable, Hashable {
    let color: String

    var intValues: [UInt32]? {
        let name = color.lowercased()
        if let value = Self.knownColors[name] {
            return [value]
        }

        if let values = Self.knownColorArrays[name] {
            return values
        }

        let simpleFilteredValues = Self.simpleColors.filter({ name.contains($0.key) })
        if !simpleFilteredValues.isEmpty {
            return simpleFilteredValues.map(\.value)
        }

        return nil
    }

    private static let knownColors: [String: UInt32] = {
        let colorsNamesPath = #file.replacingOccurrences(of: "Color.swift", with: "colorNames.json")
        let colorNamesURL = URL(fileURLWithPath: colorsNamesPath)
        let colorNamesJSON = try! Data(contentsOf: colorNamesURL)
        let colorNames = try! JSONDecoder().decode([ColorName].self, from: colorNamesJSON)
        let uniqueColorNames = Set(colorNames)
        let keysWithValues = uniqueColorNames.map { ($0.name, $0.intValue) }
        return [String: UInt32].init(uniqueKeysWithValues: keysWithValues)
    }()

    private static let knownColorArrays: [String: [UInt32]] = {
        [
            "fade carbon": [0x602a2d, 0x503032, 0x4a3e46],
            "rose whisper": [0xb38567, 0xa1897b],
            "lime blast": [0x9dd074,0xb7e08b],
            "mist": [0x9f8866, 0x877b78],
        ]
    }()

    private static let simpleColors: [String: UInt32] = {
        [
            "gray": 0x808080,
            "chrome": 0x808080,
            "silver": 0x808080,
            "grey": 0x808080,
            "platinum": 0xE5E4E2,
            "white": 0xffffff,
            "black": 0x000000,
            "blue": 0x0000FF,
            "red": 0xFF0000,
            "green": 0x00FF00,
            "pink": 0xffc0cb,
            "purple": 0x6a0dad,
            "orange": 0xFFA500,
            "violet": 0x8F00FF,
            "gold": 0xFFD700,
            "brown": 0x964B00,
            "lemon": 0xFFF700,
            "yellow": 0xFFFF00,
            "chocolate": 0x8F6251,
            "amethyst": 0xb1aaac,
        ]
    }()
}
