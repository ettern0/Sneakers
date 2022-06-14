//
//  RGB.swift
//  
//
//  Created by Alexey Salangin on 14.06.2022.
//

import Foundation

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
