//
//  LAB.swift
//  
//
//  Created by Alexey Salangin on 14.06.2022.
//

import Foundation

struct LAB {
    let l: Float
    let a: Float
    let b: Float
}

struct LabCalculator {
    static func convert(RGB: RGB) -> LAB {
        let XYZ = XYZCalculator.convert(rgb: RGB)
        let Lab = LabCalculator.convert(XYZ: XYZ)
        return Lab
    }

    static let referenceX: Float = 95.047
    static let referenceY: Float = 100.0
    static let referenceZ: Float = 108.883

    static func convert(XYZ: XYZ) -> LAB {
        func transform(value: Float) -> Float {
            if value > 0.008856 {
                return pow(value, 1 / 3)
            } else {
                return (7.787 * value) + (16 / 116)
            }
        }

        let X = transform(value: XYZ.X / referenceX)
        let Y = transform(value: XYZ.Y / referenceY)
        let Z = transform(value: XYZ.Z / referenceZ)

        let l = ((116.0 * Y) - 16.0).rounded(.toNearestOrEven)
        let a = (500.0 * (X - Y)).rounded(.toNearestOrEven)
        let b = (200.0 * (Y - Z)).rounded(.toNearestOrEven)

        return LAB(l: l, a: a, b: b)
    }
}
