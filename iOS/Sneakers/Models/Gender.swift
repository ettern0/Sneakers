//
//  Gender.swift
//  Sneakers
//
//  Created by Roman Mazeev on 07/06/22.
//

import Foundation

enum Gender: CaseIterable {
    case male
    case female

    var imageName: String {
        switch self {
        case .male:
            return ""
        case .female:
            return ""
        }
    }
}
