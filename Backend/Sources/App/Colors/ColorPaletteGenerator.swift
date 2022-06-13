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


struct RGB {
    // Percent
    let r: Float // [0,1]
    let g: Float // [0,1]
    let b: Float // [0,1]

    init(r: Float, g: Float, b: Float) {
        self.r = r
        self.g = g
        self.b = b
    }

    init(rgb: UInt32) {
        let (r, g, b) = (
            Float((rgb & 0xFF0000) >> 16) / 255,
            Float((rgb & 0x00FF00) >> 8) / 255,
            Float(rgb & 0x0000FF) / 255
        )
        self = .init(r: r, g: g, b: b)
    }

    static func hsv(r: Float, g: Float, b: Float) -> HSV {
        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)

        let v = max
        let delta = max - min

        guard delta > 0.00001 else { return HSV(h: 0, s: 0, v: max) }
        guard max > 0 else { return HSV(h: -1, s: 0, v: v) } // Undefined, achromatic grey
        let s = delta / max

        let hue: (Float, Float) -> Float = { max, delta -> Float in
            if r == max { return (g-b)/delta } // between yellow & magenta
            else if g == max { return 2 + (b-r)/delta } // between cyan & yellow
            else { return 4 + (r-g)/delta } // between magenta & cyan
        }

        let h = hue(max, delta) * 60 // In degrees

        return HSV(h: (h < 0 ? h+360 : h) , s: s, v: v)
    }

    static func hsv(rgb: RGB) -> HSV {
        return hsv(r: rgb.r, g: rgb.g, b: rgb.b)
    }

    var hsv: HSV {
        return RGB.hsv(rgb: self)
    }

    var intValue: UInt32 {
        let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return UInt32(rgb)
    }
}

struct HSV {
    var h: Float // Angle in degrees [0,360] or -1 as Undefined
    let s: Float // Percent [0,1]
    let v: Float // Percent [0,1]

    static func rgb(h: Float, s: Float, v: Float) -> RGB {
        if s == 0 { return RGB(r: v, g: v, b: v) } // Achromatic grey

        let angle = (h >= 360 ? 0 : h)
        let sector = angle / 60 // Sector
        let i = floor(sector)
        let f = sector - i // Factorial part of h

        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))

        switch(i) {
        case 0:
            return RGB(r: v, g: t, b: p)
        case 1:
            return RGB(r: q, g: v, b: p)
        case 2:
            return RGB(r: p, g: v, b: t)
        case 3:
            return RGB(r: p, g: q, b: v)
        case 4:
            return RGB(r: t, g: p, b: v)
        default:
            return RGB(r: v, g: p, b: q)
        }
    }

    static func rgb(hsv: HSV) -> RGB {
        return rgb(h: hsv.h, s: hsv.s, v: hsv.v)
    }

    var rgb: RGB {
        return HSV.rgb(hsv: self)
    }

    /// Returns a normalized point with x=h and y=v
    var point: CGPoint {
        return CGPoint(x: CGFloat(h / 360), y: CGFloat(v))
    }
}


func color(from colorName: String) -> UInt32? {
    return UInt32(123) // MARK: TODO
    //return UInt32.random(in: 0…UInt32.max)
}
