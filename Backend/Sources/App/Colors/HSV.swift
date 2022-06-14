//
//  HSV.swift
//  
//
//  Created by Alexey Salangin on 14.06.2022.
//

import Foundation

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
}
