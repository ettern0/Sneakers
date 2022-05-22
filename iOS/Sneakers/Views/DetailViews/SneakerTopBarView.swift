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

    var body: some View {
        HStack(alignment: .center) {
            LazyImage(source: sneaker.thumbnail, resizingMode: .aspectFit)
                .frame(width: height, height: height)
            VStack(alignment: .leading, spacing: 0) {
                Text(sneaker.name.capitalized)
                PaletteView(addHeader: false, position: .horizontal)
                    .frame(width: height, height: height * 0.1)
            }
            Spacer()
            Button360(sneaker: sneaker, show360: $show360)
                .frame(width: height / 2, height: height / 2)
        }
        .padding(.top, offset)
        .padding([.trailing, .leading])
    }
}
