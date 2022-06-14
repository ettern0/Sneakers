//
//  ThumbNailView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 15.06.2022.
//

import SwiftUI
import NukeUI

struct ThumbNailView: View {
    let thumbnail: String

    var body: some View {
        AsyncImage(
            url: URL(string: thumbnail), content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }, placeholder: {
                ProgressView().frame(width: 100, height: 100)
            }
        )
    }
}
