//
//  XYZ.swift
//  
//
//  Created by Alexey Salangin on 14.06.2022.
//

import Foundation

struct XYZ {
    let X: Float
    let Y: Float
    let Z: Float
}

struct XYZCalculator {
    static func convert(rgb: RGB) -> XYZ {
        func transform(value: Float) -> Float {
            if value > 0.04045 {
                return pow((value + 0.055) / 1.055, 2.4)
            }

            return value / 12.92
        }

        let red = transform(value: rgb.r) * 100.0
        let green = transform(value: rgb.g) * 100.0
        let blue = transform(value: rgb.b) * 100.0

        let X = (red * 0.4124 + green * 0.3576 + blue * 0.1805).rounded(.toNearestOrEven)
        let Y = (red * 0.2126 + green * 0.7152 + blue * 0.0722).rounded(.toNearestOrEven)
        let Z = (red * 0.0193 + green * 0.1192 + blue * 0.9505).rounded(.toNearestOrEven)

        return XYZ(X: X, Y: Y, Z: Z)
    }

}
