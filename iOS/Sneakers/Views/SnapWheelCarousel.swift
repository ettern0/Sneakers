//
//  SnapWheelCarausel.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 19.05.2022.
//

import SwiftUI
import NukeUI
import SwiftUIPager

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]

    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int

    init(spacing: CGFloat = 15,
         trailingSpace: CGFloat = 100,
         index: Binding<Int>,
         items: [T],
         @ViewBuilder content: @escaping (T) -> Content) {

        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }

    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0

    var body: some View {
        GeometryReader { proxy in

            let width = proxy.size.width

            let itemWidth = width - trailingSpace

            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: itemWidth)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -itemWidth))
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = Int(progress.rounded())
                        currentIndex = (currentIndex + roundIndex) % list.count
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}

struct Home: View {

    @StateObject var viewModel: SneakersViewModel = SneakersViewModel()
    @State var currentIndex: Int = 0

    @StateObject var page: Page = .first()

    var body: some View {
        VStack(spacing: 15) {
            Pager(page: page, data: viewModel.sneakers) { sneaker in
                VStack {
                    LazyImage(source: sneaker.thumbnail) { state in
                        if let image = state.imageContainer?.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .preferredItemSize(CGSize(width: 300, height: 400))
            .singlePagination(ratio: 0.33, sensitivity: .custom(0.2))
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchSneakers()
                } catch {
                    assertionFailure("can't getch the data")
                }
            }
        }
    }
}
