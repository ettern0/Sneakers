//
//  ContentView.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI
import NukeUI
import SwiftUIPager

struct SneakersListView: View {
    @StateObject var viewModel = SneakersViewModel.instance

    var body: some View {
        ZStack {
            Color(.init(white: 0.95, alpha: 1))
                .ignoresSafeArea()
            if viewModel.sneakers.count != 0 {
                VStack {
                    Spacer()
                    PaletteView(addHeader: true, position: .horizontal)
                        .frame(width: getRect().width * 0.7, height: getRect().height * 0.07)
                    // MARK: The carausel of sneakers
                    PagerView()
                }
                .frame(maxHeight: getRect().height / 2)

                // MARK: Details of sneaker
                if let sneaker = viewModel.detail, viewModel.showDetail {
                    SneakerDetailView(sneaker: sneaker)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                        .zIndex(1)
                }
            } else { UpdateView() }
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchSneakers()
                } catch {
                    assertionFailure("error downloading data in views")
                }
            }
        }
    }

    struct PagerView: View {
        @StateObject var viewModel = SneakersViewModel.instance
        @StateObject var page: Page = .first()

        var body: some View {
            Pager(page: page, data: viewModel.sneakers) { sneaker in
                LazyImage(source: sneaker.thumbnail) { state in
                    if let image = state.imageContainer?.image {
                        VStack(alignment: .leading, spacing: 5) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .onTapGesture {
                                    withAnimation(Animation.easeInOut(duration: 0.3)) {
                                        viewModel.detail = sneaker
                                        viewModel.showDetail = true
                                    }
                                }
                            VStack(alignment: .leading, spacing: 5) {
                                Text(sneaker.brand.capitalized)
                                Text(sneaker.name.capitalized).font(.title3).bold()
                            }
                        }
                    }
                }
            }
            .preferredItemSize(CGSize(width: getRect().width * 0.8, height: getRect().width * 0.8))
            .itemSpacing(10)
            .singlePagination(ratio: 0.33, sensitivity: .custom(0.2))
            .interactive(rotation: true)
            .interactive(scale: 0.5)
            .opacity(viewModel.showDetail ? 0 : 1)
        }
    }
}
