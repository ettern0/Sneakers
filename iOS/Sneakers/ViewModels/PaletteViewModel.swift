//
//  PaletteViewModel.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI

final class PaletteViewModel: ObservableObject {
    static let instance = PaletteViewModel(colors: [])
    @Published var palette: [Color] = []
    var key: [UInt32] = []

    init(colors: [UInt32]) {
        if colors.isEmpty {
            for _ in 0..<4 {
                self.key.append(UInt32.random(in: 0...UInt32.max))
            }
        } else {
            key = colors
        }

        key.forEach { color in

            let uiColor = UIColor(rgb: color)
            palette.append(Color(uiColor: uiColor))
        }
    }
}
