//
//  Color++.swift
//  
//
//  Created by Alexey Salangin on 12.06.2022.
//

import SwiftUI

extension Color {
    public static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}


extension Color {
    public init(rgb: UInt32) {
        self.init(UIColor(rgb: rgb))
    }
}


extension Color {
    public var uiColor: UIColor {
        .init(self)
    }
}
