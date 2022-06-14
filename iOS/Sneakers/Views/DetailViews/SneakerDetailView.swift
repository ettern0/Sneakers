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
    let colors: [UInt32]
    let viewModel: SneakersViewModel
    @StateObject var view360Model: Sneaker360ViewModel
    @State var show360: Bool = false

    init(sneaker: Sneaker, colors: [UInt32], viewModel: SneakersViewModel) {
        self.sneaker = sneaker
        self.colors = colors
        self.viewModel = viewModel
        self._view360Model = .init(wrappedValue: Sneaker360ViewModel(sneakerViewModel: viewModel))
    }

    var body: some View {
        ZStack {
            Color(.init(white: 2, alpha: 1))
                .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                SneakerHeaderView(viewModel: viewModel, sneaker: sneaker, view360Model: view360Model, show360: $show360, colors: colors)
                    .zIndex(1)
                SneakerDescriptionView(viewModel: viewModel, sneaker: sneaker, colors: colors)
                    .zIndex(0)
            }
            .coordinateSpace(name: "DETAILSCROLL")
            .sheet(isPresented: $show360) {
                Sneaker360View(viewModel: view360Model)
            }
        }
    }

    private struct SneakerHeaderView: View {
        let viewModel: SneakersViewModel
        let sneaker: Sneaker
        @StateObject var view360Model: Sneaker360ViewModel
        @Binding var show360: Bool
        @State var yOld: CGFloat = 0// First y position of geometry reader
        @State var initialGlobalYPosition: CGFloat = 0 // initial global y position on page
        @State var offset: CGFloat = 0
        let maxHeight: CGFloat = UIScreen.main.bounds.width
        let topBarHeight: CGFloat = UIScreen.main.bounds.height / 10
        let colors: [UInt32]

        var body: some View {
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    PaletteView(colors: colors, frame: (.init(width: 32, height: 32)))
                        .frame(width: getRect().width / 2, height: 32)
                        .opacity(getHeaderOpacity() == 1 ? 1 : 0)
                        .padding(.top, 24)
                    SneakerImageView(sneaker: sneaker, view360Model: view360Model)
                        .frame(width: proxy.size.width, height: proxy.size.width * 0.8)
                        .padding(.bottom, 8)
                    Button360(sneaker: sneaker, show360: $show360)
                        .padding(.bottom, 24)
                }
                .opacity(getHeaderOpacity())
                .modifier(OffsetModifier(offset: $offset))
                .onAppear {
                    yOld = proxy.frame(in: .global).minY
                    initialGlobalYPosition = proxy.frame(in: .global).minY
                }
                .onChange(of: proxy.frame(in: .global).minY) { minY in
                    if changeImage(yOld: yOld, yNew: minY) { yOld = minY }
                }
                .background(
                    VStack {
                    ZStack(alignment: .top) {
                        Color.white
                            .offset(y: -proxy.frame(in: .global).minY + initialGlobalYPosition)
                            .frame(maxHeight: topBarHeight)
                        SneakerTopBarView(sneaker: sneaker, height: topBarHeight, show360: $show360, offset: 0, colors: colors)
                            .offset(y: -proxy.frame(in: .global).minY + initialGlobalYPosition)
                            .animation(.easeInOut, value: offset)
                    }
                        Spacer()
                    }.opacity(getTopBarTitleOpacity())
                )
            }
            .frame(width: getRect().width, height: getRect().width)
        }

        func changeImage(yOld: CGFloat, yNew: CGFloat) -> Bool {
            guard view360Model.images.count != 0 else { return false }

            if yNew <= initialGlobalYPosition {
                withAnimation {
                    view360Model.active = view360Model.images[0]
                }
                return true
            }

            guard abs(yOld - yNew) > getRect().height / 100 else { return false }

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
            if getHeaderOpacity() <= 0.2 {
                return topBarHeight / getHeaderHeight()
            }
            return 0
        }
    }
}
