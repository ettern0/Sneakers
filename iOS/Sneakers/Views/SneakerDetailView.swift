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
                SneakerDescriptionView(sneaker: sneaker)
            }
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

        var body: some View {
            GeometryReader { proxy in
                VStack(spacing: spacing) {
                    RollUpView()
                        .frame(width: getRect().width / 4, height: rollUpHeight)
                        .padding(.top, safeAreaInsets?.top)
                        .offset(y: -proxy.frame(in: .global).minY)
                    PaletteView(addHeader: false)
                        .frame(width: getRect().width * 0.7, height: paletteHeight)
                        .offset(y: -proxy.frame(in: .global).minY + spacing)
                    ZStack(alignment: .top) {
                        SneakerImageView(sneaker: sneaker, view360Model: view360Model)
                            .frame(width: imageFrame,
                                   height: proxy.frame(in: .global).minY > 0 ?
                                   proxy.frame(in: .global).minY + imageFrame :
                                    imageFrame)
                            .offset(y: -proxy.frame(in: .global).minY)
                        HStack {
                            Spacer()
                            Button360(show360: $show360)
                                .frame(width: 36, height: 36, alignment: .trailing)
                                .padding(.top, safeAreaInsets?.top)
                                .padding()
                                .offset(y: -proxy.frame(in: .global).minY)
                        }
                    }
                }
                .onAppear {
                    // Set first position
                    yOld = proxy.frame(in: .global).minY
                }
                .onChange(of: proxy.frame(in: .global).minY) { minY in
                    if minY >= getRect().height * 0.15 {
                        withAnimation(.easeInOut) {
                            viewModel.showDetail = false
                        }
                    }
                    if changeImage(yOld: yOld, yNew: minY) {
                        yOld = minY
                    }
                }
            }
            .frame(width: getRect().width, height: getRect().width)
        }

        private struct SneakerImageView: View {
            let sneaker: Sneaker
            @StateObject var view360Model: Sneaker360ViewModel

            var body: some View {
                if sneaker.has360, let image = view360Model.active {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if sneaker.has360 {
                    UpdateView()
                } else {
                    LazyImage(source: sneaker.thumbnail, resizingMode: .aspectFit)
                        .aspectRatio(contentMode: .fill)
                }
            }
        }

        private struct RollUpView: View {
            var body: some View {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(.black)
                    .opacity(0.5)
            }
        }

        private struct Button360: View {
            @Binding var show360: Bool
            var body: some View {
                Button {
                    show360 = true
                } label: {
                    Image(systemName: "arkit")
                        .resizable()
                        .foregroundColor(.black)
                        .opacity(0.5)
                }
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
            print(index)
            return true
        }
    }

    private struct SneakerDescriptionView: View {
        let sneaker: Sneaker
        @StateObject var viewModel: SneakersViewModel = SneakersViewModel.instance

        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(sneaker.brand.capitalized).font(.title3).opacity(0.8)
                Text(sneaker.name.capitalized).font(.largeTitle).bold()
                Text("Price range: 120.000$  - 180.000$").italic().padding(.bottom, 15).opacity(0.5)
                Text("Description".capitalized).font(.title3).bold().padding(.bottom, 10)
                Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: "")).bold()
            }
            .padding()
            .background(Color.white)
        }
    }
}
