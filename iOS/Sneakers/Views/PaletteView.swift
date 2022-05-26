//
//  PaleteView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI

struct PaletteView: View {
    @StateObject var viewModel: PaletteViewModel = PaletteViewModel.instance
    let addHeader: Bool
    let position: Axis.Set

    let paletteHeight: CGFloat = 12

    var body: some View {
        GeometryReader {
        VStack(spacing: 10) {
            if addHeader {
                Text("Your Palette")
            }
            if position == .horizontal {
                HStack(spacing: 4) {
                    ForEach(viewModel.palette, id: \.self) { color in
                        color
                    }
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(viewModel.palette, id: \.self) { color in
                        color
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        .frame(width: $0.size.width * 0.6, height: paletteHeight)
        }
    }
}
