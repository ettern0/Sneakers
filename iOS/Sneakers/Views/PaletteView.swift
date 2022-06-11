//
//  PaleteView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI

struct PaletteView: View {
    @StateObject var viewModel: PaletteViewModel
    // let position: Axis.Set
    let paletteHeight: CGFloat = 12

    var body: some View {
        HStack(spacing: 10) {
            ForEach(viewModel.palette, id: \.self) { color in
                color.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
    }
}
