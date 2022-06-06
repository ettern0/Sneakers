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
    @State private var image: UIImage
    @State private var selectedIndices: [Int] = [0, 1]

    init(image: UIImage) {
        self.image = image
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Detect")
                    .font(.headline)
                Text("Select two main colors")
            }
            .padding(.horizontal, 40)

            GeometryReader { proxy in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 12)

            VStack(alignment: .center, spacing: 0) {
                PaletteControl(
                    colors: ColorFinder().colors(from: image),
                    selectedIndices: $selectedIndices
                )
                .padding(.horizontal, 40)
                .padding(.vertical, 16)

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
