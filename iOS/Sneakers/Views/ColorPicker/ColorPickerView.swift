//
//  ColorPickerView.swift
//  Sneakers
//
//  Created by Alexey Salangin on 04.06.2022.
//

import SwiftUI
import DesignSystem

struct ColorPickerView: View {
    var body: some View {
        Text("Detect")
        Text("Select two main colors")
        Image("")
        PaletteView(viewModel: .init(from: [0xFF0000, 0x00FF00, 0xF8A112]))
            .fixedSize()
        Button("Explore results") {
            print("Explore")
        }
        .buttonStyle(LargeButtonStyle())
        .padding(16)
    }
}
