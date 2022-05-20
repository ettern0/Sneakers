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
    @StateObject var viewModel = SneakersViewModel()
    @StateObject var page: Page = .first()
    @Namespace var animation

    var body: some View {
        ZStack {
            // MARK: The carausel of sneakers
            Pager(page: page, data: viewModel.sneakers) { sneaker in
                LazyImage(source: sneaker.thumbnail) { state in
                    if let image = state.imageContainer?.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .matchedGeometryEffect(id: sneaker.id, in: animation)
                            .onTapGesture {
                                withAnimation(Animation.easeInOut(duration: 0.3)) {
                                    viewModel.detail = sneaker
                                    viewModel.showDetail = true
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

            // MARK: Details of sneaker
            if let sneaker = viewModel.detail, viewModel.showDetail {
                SneakerDetailView(sneaker: sneaker, animation: animation)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    .zIndex(1)
                    .environmentObject(viewModel)
            }
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
}
