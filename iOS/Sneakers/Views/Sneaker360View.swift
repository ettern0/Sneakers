//
//  360View.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 18.05.2022.
//

import SwiftUI
import Lottie

struct View360: View {
    @StateObject var viewModel: Sneaker360ViewModel = Sneaker360ViewModel()

    var body: some View {
            if let uiImage = viewModel.active {
                VStack(spacing: 20) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: getRect().width, height: getRect().width)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                changeImage(xOld: value.startLocation.x, xNew: value.location.x)
                            })}
                LottieView(lottieFile: "lottieSwipe")
                    .frame(width: getRect().width, height: getRect().height / 10)
            }
    }

    func changeImage(xOld: CGFloat, xNew: CGFloat) {
        guard abs(xOld - xNew) > getRect().width / 10 else { return }
        var index: Int = 0

        if let active = viewModel.active, let activeIndex = viewModel.images.firstIndex(of: active) {
            index = activeIndex
        }
        if xOld < xNew {
            index -= 1
        } else {
            index += 1
        }
        if index > viewModel.images.count - 1{
            index = 0
        } else if index < 0 {
            index = viewModel.images.count - 1
        }
        viewModel.active = viewModel.images[index]
    }
}


