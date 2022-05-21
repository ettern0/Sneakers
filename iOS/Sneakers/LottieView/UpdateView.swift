//
//  DataUpdatingView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI
import Lottie

struct UpdateView: View {
    var body: some View {
        LottieView(lottieFile: "download360")
            .frame(width: getRect().width / 4, height: getRect().width / 4)
    }
}
