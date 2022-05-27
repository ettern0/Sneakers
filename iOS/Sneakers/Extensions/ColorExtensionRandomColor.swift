//
//  ColorExtensionRandomColor.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}


extension Color {
    init(rgb: UInt32) {
        self.init(UIColor(rgb: rgb))
    }
}


extension Color {
    var uiColor: UIColor {
        .init(self)
    }
}
