//
//  360View.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 18.05.2022.
//

import SwiftUI
import Lottie

struct Sneaker360View: View {
    @StateObject var viewModel: Sneaker360ViewModel

    var body: some View {
        VStack {
            if let uiImage = viewModel.active {
                VStack(spacing: 20) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: getRect().width)
                        .onAppear { // Make a initial animation with rotation
                            withAnimation {
                                makeDemoRotation()
                            }
                        }
                }
                SwipeView()
            } else { UpdateView() }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    changeImage(xOld: value.startLocation.x, xNew: value.location.x)
                })
    }

    func makeDemoRotation() {

        var delay: Double = 0
        for index in 0..<viewModel.images.count {
            delay += 0.02
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                viewModel.active = viewModel.images[index]
            }
        }

        for index in 0..<viewModel.images.count / 5 {
            delay += 0.02
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                viewModel.active = viewModel.images[index]
            }
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
        if index > viewModel.images.count - 1 {
            index = 0
        } else if index < 0 {
            index = viewModel.images.count - 1
        }
        viewModel.active = viewModel.images[index]
    }
}
