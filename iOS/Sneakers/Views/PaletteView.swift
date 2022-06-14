//
//  PaleteView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI

struct PaletteView: View {
    let colors: [UInt32]
    let frame: CGSize
    var cornerRadius: CGFloat = 5

    var body: some View {
        HStack(spacing: 10) {
            ForEach(colors.indices, id: \.self) { index in
                Color(rgb: colors[index])
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .frame(width: frame.width, height: frame.height)
            }
        }
    }
}
