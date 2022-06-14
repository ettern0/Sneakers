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
            headerView
            descriprionView
            paletteView
        }
    }

    var headerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Detect")
                .font(Font.ralewayBold(size: 32))
        }
        .padding(.horizontal, 40)
    }

    var descriprionView: some View {
        VStack(alignment: .center) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
            Text("Base your choice on two main color")
                .font(Font.ralewaySemiBold(size: 16))
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .padding(.vertical, 12)
    }

    var paletteView: some View {
        VStack(spacing: 0) {
            PaletteControl(
                colors: colors,
                selectedIndices: $selectedIndices
            )
            .padding(.horizontal, 40)
            .padding(.vertical, 16)

            Button {
                let selectedColors = selectedIndices.map { colors[$0] }
                let input = SneakersInput(outfitColors: selectedColors)
                router.push(screen: .sneakers(input))
            } label: {
                Text("Explore results")
                    .font(Font.ralewayMedium(size: 18))
            }
            .disabled(selectedIndices.count != 2)
            .buttonStyle(LargeButtonStyle())
            .padding(16)
        }.frame(maxWidth: .infinity)
    }
}
