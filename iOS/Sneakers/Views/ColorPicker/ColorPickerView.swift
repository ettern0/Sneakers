//
//  ColorPickerView.swift
//  Sneakers
//
//  Created by Alexey Salangin on 04.06.2022.
//

import SwiftUI
import UIKit
import Combine

import DesignSystem
import CoreUtils

struct ColorPickerInput {
    let image: UIImage
    let colors: [UInt32]
}

struct ColorPickerView: View {
    @State private var image: UIImage
    @State private var selectedIndices: [Int] = [0, 1]
    @EnvironmentObject private var router: Router
    @State private var colors: [UInt32]

    init(input: ColorPickerInput) {
        self.image = input.image
        self.colors = input.colors
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Detect")
                Text("Select two main colors")
            }
            .padding(.horizontal, 40)

            VStack(alignment: .center) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 40)
            .padding(.vertical, 12)

            VStack(spacing: 0) {
                PaletteControl(
                    colors: colors,
                    selectedIndices: $selectedIndices
                )
                .padding(.horizontal, 40)
                .padding(.vertical, 16)

                Button("Explore results") {
                    let selectedColors = selectedIndices.map { colors[$0] }
                    let input = SneakersInput(outfitColors: selectedColors)
                    router.push(screen: .sneakers(input))
                }
                .disabled(selectedIndices.count != 2)
                .buttonStyle(LargeButtonStyle())
                .padding(16)
            }.frame(maxWidth: .infinity)
        }
    }
}