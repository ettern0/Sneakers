//
//  ColorPickerView.swift
//  Sneakers
//
//  Created by Alexey Salangin on 04.06.2022.
//

import SwiftUI
import UIKit

import DesignSystem
import CoreUtils

struct ColorPickerView: View {
    let image: UIImage
    @State var selectedIndices: [Int] = [0, 1]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Detect")
                    .font(.headline)
                Text("Select two main colors")
            }
            .padding(.horizontal, 40)

            Image(uiImage: image)
                .resizable()
                .padding(.horizontal, 40)
                .padding(.vertical, 12)

            VStack(alignment: .center, spacing: 0) {
                PaletteControl(
                    colors: [0xFF0000, 0x00FF00, 0xF8A112, 0x6545D0],
                    selectedIndices: $selectedIndices
                )
                .padding(.horizontal, 40)

                Button("Explore results") {
                    print("Explore")
                }
                .disabled(selectedIndices.count != 2)
                .buttonStyle(LargeButtonStyle())
                .padding(16)
            }
        }
    }
}
