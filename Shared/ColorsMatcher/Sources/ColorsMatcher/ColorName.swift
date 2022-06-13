//
//  ColorName.swift
//  ColorsMatcher
//
//  Created by Alexey Salangin on 13.06.2022.
//

import Foundation

struct ColorName {
    let name: String
    let hex: String

    var intValue: UInt32 {
        UInt32(hex.dropFirst(1), radix: 16) ?? 0
    }
}

extension ColorName: Decodable {
    enum CodingKeys: CodingKey {
        case name
        case hex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name).lowercased()
        self.hex = try container.decode(String.self, forKey: .hex)
    }
}

extension ColorName: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: ColorName, rhs: ColorName) -> Bool {
        lhs.name == rhs.name
    }
}
