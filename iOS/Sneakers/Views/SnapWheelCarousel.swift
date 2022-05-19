//
//  SnapWheelCarausel.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 19.05.2022.
//

import SwiftUI
import NukeUI

struct SnapCarausel<Content: View, T: Identifiable>: View {
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

            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 2), 0)
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}

struct Home: View {

    @StateObject var viewModel: SneakersListViewModel = SneakersListViewModel()
    @State var currentIndex: Int = 0

    var body: some View {
        VStack(spacing: 15) {
            SnapCarausel(index: $currentIndex, items: viewModel.sneakers) { sneaker in
                GeometryReader { proxy in
                    let size = proxy.size
                    let url = sneaker.thumbnail
                    VStack {
                    LazyImage(source: sneaker.thumbnail) { state in
                        if let image = state.imageContainer?.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width)
                                .cornerRadius(12)
                        } else {
                            var ds = 1
                        }
                    }
                        Text(url)
                    }
                    .padding(.vertical, 80)
                }
            }
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
