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

    var body: some View {
        VStack(spacing: 10) {
            if addHeader {
                Text("Your Palette")
            }
            HStack(spacing: 0) {
                ForEach(viewModel.palette, id: \.self) { color in
                    color
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        }
    }
}
