//
//  SneakerDetail.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI
import NukeUI

struct SneakerDetailView: View {
    var sneaker: Sneaker
    @StateObject var viewModel: SneakersViewModel = SneakersViewModel.instance
    @StateObject var view360Model: Sneaker360ViewModel = Sneaker360ViewModel()
    @State var show360: Bool = false

    var body: some View {
        ZStack {
            Color(.init(white: 2, alpha: 1))
                .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                SneakerHeaderView(sneaker: sneaker, view360Model: view360Model, show360: $show360)
                    .zIndex(1)
                SneakerDescriptionView(sneaker: sneaker)
                    .zIndex(0)
            }
            .coordinateSpace(name: "DETAILSCROLL")
            .ignoresSafeArea()
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $show360) {
                Sneaker360View()
            }
        }
    }

    private struct SneakerHeaderView: View {
        let sneaker: Sneaker
        @StateObject var viewModel: SneakersViewModel = SneakersViewModel.instance
        @StateObject var view360Model: Sneaker360ViewModel
        @Binding var show360: Bool
        let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
        let rollUpHeight: CGFloat = 5
        let paletteHeight: CGFloat = UIScreen.main.bounds.height * 0.03
        @State var yOld: CGFloat = 0// First y position of geometry reader
        let spacing: CGFloat = 10
        var imageFrame: CGFloat {
            UIScreen.main.bounds.width - rollUpHeight - paletteHeight - spacing - (safeAreaInsets?.top ?? 0)
        }

        let maxHeight: CGFloat = UIScreen.main.bounds.width
        let topBarHeight: CGFloat = UIScreen.main.bounds.height / 10
        @State var offset: CGFloat = 0

        var body: some View {
            GeometryReader { proxy in
                VStack {
                    RollUpView()
                        .frame(width: getRect().width / 4, height: rollUpHeight)
                        .padding(.top, safeAreaInsets?.top)
                        .opacity(getHeaderOpacity() == 1 ? 1 : 0)
                    PaletteView(addHeader: false, position: .horizontal)
                        .frame(width: getRect().width * 0.7, height: paletteHeight)
                        .opacity(getHeaderOpacity() == 1 ? 1 : 0)
                    ZStack(alignment: .top) {
                        SneakerImageView(sneaker: sneaker, view360Model: view360Model)
                            .frame(width: imageFrame,
                                   height: proxy.frame(in: .global).minY > 0 ? proxy.frame(in: .global).minY + imageFrame : imageFrame)
                        main360Button
                    }
                }
                .offset(y: -proxy.frame(in: .global).minY)
                .opacity(getHeaderOpacity())
                .frame(height: getHeaderHeight())
                .modifier(OffsetModifier(offset: $offset))
                .onAppear { yOld = proxy.frame(in: .global).minY }// Set first position
                .onChange(of: proxy.frame(in: .global).minY) { minY in
                    if minY >= getRect().height * 0.15 {
                        withAnimation(.easeInOut) { viewModel.showDetail = false }
                    }
                    if changeImage(yOld: yOld, yNew: minY) { yOld = minY }
                }
                .background(
                    ZStack(alignment: .top) {
                        Color.white
                            .offset(y: -proxy.frame(in: .global).minY)
                        SneakerTopBarView(sneaker: sneaker, height: topBarHeight, show360: $show360, offset: (safeAreaInsets?.top ?? 0))
                            .offset(y: -proxy.frame(in: .global).minY)
                            .opacity(getTopBarTitleOpacity())
                            .animation(.easeInOut, value: offset)
                    })
            }
            .frame(width: getRect().width, height: getRect().width)
        }

        var main360Button: some View {
            HStack {
                Spacer()
                Button360(sneaker: sneaker, show360: $show360)
                    .frame(width: topBarHeight / 2, height: topBarHeight / 2, alignment: .trailing)
                    .padding(.top, safeAreaInsets?.top)
                    .padding()
            }
        }

        func changeImage(yOld: CGFloat, yNew: CGFloat) -> Bool {
            guard abs(yOld - yNew) > getRect().height / 100 else { return false }
            guard view360Model.images.count != 0 else { return false }
            guard yNew > 0 else { return false }
            var index: Int = 0

            if let active = view360Model.active, let activeIndex = view360Model.images.firstIndex(of: active) {
                index = activeIndex
            }
            if yOld > yNew {
                index -= 1
            } else {
                index += 1
            }
            if index > view360Model.images.count - 1 {
                index = 0
            } else if index < 0 {
                index = 0
            }
            index = min(index, 5)
            withAnimation {
                view360Model.active = view360Model.images[index]
            }
            return true
        }

        func getHeaderHeight() -> CGFloat {
            let topHeight = maxHeight + offset
            let result = topHeight > topBarHeight ? topHeight : topBarHeight
            return result
        }

        func getHeaderOpacity() -> CGFloat {
            let progress = -offset / 200
            let opacity = 1 - progress
            return offset < 0 ? opacity : 1
        }

        func getTopBarTitleOpacity() -> CGFloat {
            if getHeaderOpacity() <= 0 {
                return topBarHeight / getHeaderHeight()
            }
            return 0
        }
    }
}