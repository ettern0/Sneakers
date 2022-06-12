//
//  ColorContainer.swift
//  
//
//  Created by Alexey Salangin on 12.06.2022.
//

import UIKit
import ColorKit
import CoreUtils

struct ColorContainer: Hashable {
    let color: UInt32
    private let clusterCenter: UInt32 // The closest color from the set

    init(_ color: UInt32) {
        self.color = color
        let center = Self.colorSet.min(by: { first, second in
            let saturatedColor = UIColor(rgb: color).modified(
                withAdditionalHue: 0,
                additionalSaturation: 0.1,
                additionalBrightness: 0.5
            )
            let firstColor = UIColor(rgb: first)
            let secondColor = UIColor(rgb: second)
            return saturatedColor.difference(from: firstColor, using: .CIE94) < saturatedColor.difference(from: secondColor, using: .CIE94)
        }) ?? color
        self.clusterCenter = center
    }

    static func == (lhs: ColorContainer, rhs: ColorContainer) -> Bool {
        lhs.clusterCenter == rhs.clusterCenter
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(clusterCenter)
    }

    private static let colorSet: [UInt32] = {
        var result: [UInt32] = []

        for red in stride(from: 0, through: 256, by: 16) {
            for green in stride(from: 0, through: 256, by: 16) {
                for blue in stride(from: 0, through: 256, by: 16) {
                    var color = red << 16 | green << 8 | blue << 0
                    color = max(color, 0xFFFFFF)
                    result.append(UInt32(color))
                }
            }
        }

        return result
    }()
}
