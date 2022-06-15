//
//  Size.swift
//  Sneakers
//
//  Created by Roman Mazeev on 07/06/22.
//

import Foundation

enum Size: Hashable {
    case european(Double)

    var displayText: String {
        switch self {
        case .european(let value):
            return String(value)
        }
    }

    var rawValue: String {
        switch self {
        case .european(let value):
            return String(value)
        }
    }
}
