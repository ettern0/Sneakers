//
//  SneakerTopBarView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//

import SwiftUI
import NukeUI

struct SneakerTopBarView: View {
    let sneaker: Sneaker
    let height: CGFloat
    @Binding var show360: Bool
    let offset: CGFloat
    let colors: [UInt32]

    var body: some View {
        HStack(alignment: .center) {
            LazyImage(source: sneaker.thumbnail, resizingMode: .aspectFit)
                .frame(width: height, height: height)
            VStack(alignment: .leading, spacing: 0) {
                Text(sneaker.name.capitalized)
                    .font(Font.ralewayRegular(size: 15))
                PaletteView(colors: colors, frame: (.init(width: 12, height: 12)), cornerRadius: 2)
                    .frame(width: height, height: height * 0.2)
            }
            Spacer()
            Button360(sneaker: sneaker, show360: $show360)
                .frame(maxHeight: height / 2)
        }
        .padding(.top, offset)
        .padding([.trailing, .leading])
    }
}
