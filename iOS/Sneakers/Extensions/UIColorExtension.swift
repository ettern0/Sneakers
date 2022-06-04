//
//  ColorExtension.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 26.05.2022.
//

import SwiftUI

extension UIColor {
    public convenience init(rgb: UInt32, alpha: CGFloat = 1) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgb & 0x0000FF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    var color: Color {
        .init(self)
    }
}
