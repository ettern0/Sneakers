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

    var intValue: UInt32 {
        let (red, green, blue, _) = self.components
        let rgb = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return UInt32(rgb)
    }

    // swiftlint:disable:next large_tuple
    private var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let components = self.cgColor.components else {
            assertionFailure()
            return (0, 0, 0, 0)
        }
        if components.count == 2 {
            return (components[0], components[0], components[0], components[1])
        } else if components.count == 4 {
            return (components[0], components[1], components[2], components[3])
        } else {
            assertionFailure()
            return (0, 0, 0, 0)
        }
    }
}
