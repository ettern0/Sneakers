//
//  Size.swift
//  Sneakers
//
//  Created by Roman Mazeev on 07/06/22.
//

import Foundation

enum Size: Hashable {
    case european(Int)

    var displayText: String {
        switch self {
        case .european(let value):
            return String(value)
        }
    }
}
