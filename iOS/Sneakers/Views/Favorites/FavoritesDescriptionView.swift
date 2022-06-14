//
//  FavoritesDescriptionView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 15.06.2022.
//

import SwiftUI

struct FavoritesDescriptionView: View {
    let brand: String
    let name: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(brand.capitalized)
                .font(Font.ralewayMediumItalic(size: 13))
            Text(name.capitalized)
                    .font(Font.ralewaySemiBold(size: 12))
        }
        .frame(maxWidth: 100, maxHeight: 100)
    }
}
