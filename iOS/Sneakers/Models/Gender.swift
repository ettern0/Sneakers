//
//  Gender.swift
//  Sneakers
//
//  Created by Roman Mazeev on 07/06/22.
//

import Foundation

enum Gender: Int, CaseIterable {
    case male = 0
    case female = 1

    var imageName: String {
        switch self {
        case .male:
            return "maleGender"
        case .female:
            return "femaleGender"
        }
    }
}
