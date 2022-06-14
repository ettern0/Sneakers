//
//  ColorDistance.swift
//  
//
//  Created by Alexey Salangin on 14.06.2022.
//

import Foundation

enum ColorDistance {
    static func distance(from: UInt32, to: UInt32) -> Float {
        let lab1 = LabCalculator.convert(RGB: RGB(rgb: from))
        let lab2 = LabCalculator.convert(RGB: RGB(rgb: to))

        let distance = Self.deltaECIE94(lhs: lab1, rhs: lab2)
        return distance
    }

    private static func deltaECIE94(lhs: LAB, rhs: LAB) -> Float {
        let kL: Float = 1.0
        let kC: Float = 1.0
        let kH: Float = 1.0
        let k1: Float = 0.045
        let k2: Float = 0.015
        let sL: Float = 1.0

        let c1 = sqrt(pow(lhs.a, 2) + pow(lhs.b, 2))
        let sC = 1 + k1 * c1
        let sH = 1 + k2 * c1

        let deltaL = lhs.l - rhs.l
        let deltaA = lhs.a - rhs.a
        let deltaB = lhs.b - rhs.b

        let c2 = sqrt(pow(rhs.a, 2) + pow(rhs.b, 2))
        let deltaCab = c1 - c2

        let deltaHab = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaCab, 2))

        let p1 = pow(deltaL / (kL * sL), 2)
        let p2 = pow(deltaCab / (kC * sC), 2)
        let p3 = pow(deltaHab / (kH * sH), 2)

        let deltaE = sqrt(p1 + p2 + p3)

        return deltaE
    }
}
