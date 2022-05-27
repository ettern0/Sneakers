//
//  SneakerImageView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//

import SwiftUI
import NukeUI

struct SneakerImageView: View {
    let sneaker: Sneaker
    @StateObject var view360Model: Sneaker360ViewModel

    var body: some View {
        if sneaker.has360, let image = view360Model.active {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if sneaker.has360 {
            ZStack(alignment: .center) {
                UpdateView()
            }
        } else {
            LazyImage(source: sneaker.thumbnail, resizingMode: .aspectFit)
                .aspectRatio(contentMode: .fit)
        }
    }
}
