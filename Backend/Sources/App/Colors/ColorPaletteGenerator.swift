//
//  ColorPaletteGenerator.swift
//  
//
//  Created by Alexey Salangin on 12.06.2022.
//

import Foundation
import SneakerModels

enum ColorPaletteGenerator {
    static func palettes(from colors: [UInt32]) -> [ColorPalette]? {
        switch colors.count {
        case 1:
            return [
                ColorPalette(
                    harmony: .splitComplementary,
                    sourceColors: colors,
                    suggestedColors: Self.splitComplementary(for: colors[0])
                )
            ]
        case 2:
            return Self.splitComplementary(first: colors[0], second: colors[1]).map {
                ColorPalette(
                    harmony: .splitComplementary,
                    sourceColors: colors,
                    suggestedColors: $0
                )
            }
            + []
        default:
            return nil
        }
    }

    private static func splitComplementary(for color: UInt32) -> [UInt32] { // TODO: return 3 possible palettes
        let rgb = RGB(rgb: color)
        let hsv = rgb.hsv
        var first = hsv
        first.h = Float((Int(first.h.rounded()) + 150) % 360)
        var second = hsv
        second.h = Float((Int(second.h.rounded()) + 210) % 360)

        let firstRGB = first.rgb
        let secondRGB = second.rgb

        return [
            firstRGB.intValue,
            secondRGB.intValue
        ]
    }

    private static func splitComplementary(first: UInt32, second: UInt32) -> [[UInt32]] {
        let rgb1 = RGB(rgb: first)
        let rgb2 = RGB(rgb: second)

        let hsv1 = rgb1.hsv
        let hsv2 = rgb2.hsv

        var deltaH = abs(hsv1.h - hsv2.h)
        deltaH = min(360 - deltaH, deltaH)

        let minH = min(hsv1.h, hsv2.h)
        let maxH = max(hsv1.h, hsv2.h)
        var palettes: [[UInt32]] = []

        if deltaH < 60 {
            let hue = Float(Int((minH + deltaH / 2 + 180).rounded()) % 360)
            let color = HSV(h: hue, s: (hsv1.s + hsv2.s) / 2, v: (hsv1.v + hsv2.v) / 2)
            palettes.append([color.rgb.intValue])
        } else {
            let hue1 = Float(Int((minH - deltaH).rounded()) % 360)
            let hue2 = Float(Int((maxH + deltaH).rounded()) % 360)
            let color1 = HSV(h: hue1, s: (hsv1.s + hsv2.s) / 2, v: (hsv1.v + hsv2.v) / 2)
            let color2 = HSV(h: hue2, s: (hsv1.s + hsv2.s) / 2, v: (hsv1.v + hsv2.v) / 2)
            palettes.append([color1.rgb.intValue])

            if abs(hue2 - hue1) > 20 {
                palettes.append([color2.rgb.intValue])
            }
        }

        return palettes
    }
}
