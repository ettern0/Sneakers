//
//  ContentView.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI
import NukeUI

struct SneakersListView: View {
    @StateObject var viewModel = SneakersListViewModel()
    @StateObject var sharedData = SharedDataModel()
    @Namespace var animation

    var spcaing: CGFloat { 10 }
    var widthOfHiddenCards: CGFloat {
        getRect().width / 8
    }
    var sizeOfCentralCard: CGFloat {
        getRect().width - (widthOfHiddenCards * 2) - (spacing * 2)
    }
    var spacing: CGFloat { 10 }

    var body: some View {

        ZStack {
            // MARK: The carausel of sneakers
            Canvas {
                Carousel(numberOfItems: CGFloat( viewModel.sneakers.count ), spacing: spacing, widthOfHiddenCards: widthOfHiddenCards ) {
                    ForEach(viewModel.sneakers) { sneaker in
                        if let id_db = sneaker.id, let id = viewModel.cache.map[id_db] {
                            Item( _id: id) {
                                SneakerCardView(sneaker: sneaker, viewModel: viewModel, sharedData: sharedData)
                                    .matchedGeometryEffect(id: sneaker.id, in: animation)
                                    .frame(width: sizeOfCentralCard,
                                           height: sizeOfCentralCard)
                                    .transition(AnyTransition.slide)
                                    .opacity(sharedData.showDetailProduct ? 0 : 1)
                                    .animation(.spring(), value: viewModel.active)
                            }
                        }
                    }
                }
                .environmentObject(self.viewModel)
            }
            .opacity(sharedData.showDetailProduct ? 0 : 1)

            // MARK: Details of sneaker
            if let sneaker = sharedData.detail, sharedData.showDetailProduct {
                SneakerDetailView(sneaker: sneaker, animation: animation)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    .zIndex(1)
                    .environmentObject(sharedData)
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

    private struct Item<Content: View>: View {
        var _id: Int
        var content: Content

        init(_id: Int, @ViewBuilder _ content: () -> Content) {
            self.content = content()
            self._id = _id
        }

        var body: some View {
            content
        }
    }

    private struct SneakerCardView: View {
        let sneaker: Sneaker
        @StateObject var viewModel: SneakersListViewModel
        let sharedData: SharedDataModel

        var body: some View {
            VStack {
            LazyImage(source: sneaker.thumbnail, resizingMode: .aspectFit)
                .onTapGesture {
                    withAnimation(Animation.easeInOut(duration: 0.3)) {
                        sharedData.detail = sneaker
                        sharedData.showDetailProduct = true
                    }
                }

                if let id_db = sneaker.id, let id = viewModel.cache.map[id_db], id == viewModel.active {
                    Text(sneaker.shoeName.capitalized)
                }
            }
        }

        private func getImageWithoutBackground(from source: String) -> some View {
            LazyImage(source: source) { state in
                if let container = state.imageContainer,
                    let image = container.image,
                    let prepImage = image.removeBackground(returnResult: .finalImage) {
                    Image(prepImage)
                }
            }
        }
    }
}
