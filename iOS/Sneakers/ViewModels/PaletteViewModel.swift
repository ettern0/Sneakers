//
//  PaletteViewModel.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI

class PaletteViewModel: ObservableObject {
    static let instance = PaletteViewModel()
    @Published var palette: [Color] = []

    init() {
        if palette.isEmpty {
            for _ in 0..<5 {
                palette.append(Color.random)
            }
        }
    }
}
