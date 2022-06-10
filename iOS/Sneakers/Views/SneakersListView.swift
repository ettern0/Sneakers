//
//  ContentView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI
import NukeUI
import SwiftUIPager

struct SneakersInput {
    let outfitColors: [UInt32]
}

struct SneakersListView: View {
    let input: SneakersInput

    @StateObject var viewModel = SneakersViewModel.instance
    @StateObject var filterViewModel: FiltersViewModel
    @State var showDetails: Bool = false
    @State var showFilters: Bool = false

    init(input: SneakersInput) {
        self.input = input
        self._filterViewModel =  .init(wrappedValue: FiltersViewModel(palette: input.outfitColors)) // MARK: Replace with correct outfit
    }

    var body: some View {
        ZStack {
            Color(.init(white: 0.95, alpha: 1))
                .ignoresSafeArea()
            if viewModel.sneakers.count != 0 {
                VStack {
                    Spacer()
                    PaletteView(viewModel: .init(colors: input.outfitColors))
                        .frame(width: getRect().width * 0.7, height: getRect().height * 0.07)
                    PagerView(showDetail: $showDetails)
                }
                .frame(maxHeight: getRect().height / 2)
                .sheet(isPresented: $showDetails) {
                    if let sneaker = viewModel.detail {
                        SneakerDetailView(sneaker: sneaker, input: input)
                    }
                }
                .sheet(isPresented: $showFilters) {
                    FiltersView(
                        viewModel: filterViewModel,
                        slider: .init(start: filterViewModel.priceRange.min, end: filterViewModel.priceRange.max)
                    )
                }
            } else { UpdateView() }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilters = true
                } label: {
                    Text("filter")
                }
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

    struct PagerView: View {
        @StateObject var viewModel = SneakersViewModel.instance
        @StateObject var page: Page = .first()
        @Binding var showDetail: Bool

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
                                        showDetail = true
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
        }
    }
}
