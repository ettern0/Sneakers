//
//  Color.swift
//  ColorsMatcher
//
//  Created by Alexey Salangin on 13.06.2022.
//

import ColorsMatcher
import Foundation

struct Color: Decodable, Hashable {
    let color: String

    var intValues: [UInt32]? {
        ColorsMatcher.colors(for: color)
    }
}
