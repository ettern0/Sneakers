//
//  SwipeView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI
import Lottie

struct SwipeView: View {
    var body: some View {
        LottieView(lottieFile: "lottieSwipe")
            .frame(width: getRect().width, height: getRect().height / 10)
    }
}
