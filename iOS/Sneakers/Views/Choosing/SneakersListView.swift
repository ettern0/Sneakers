//
//  ContentView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI
import NukeUI
import SwiftUIPager
import DesignSystem
import SneakerModels

struct SneakersInput {
    let outfitColors: [UInt32]
}

struct SneakersListView: View {
    let input: SneakersInput

    @StateObject @MainActor var viewModel: SneakersViewModel
    @State var showDetails: Bool = false
    @State var showFilters: Bool = false

    var selectedIndexBinding: Binding<Int> {
        .init {
            self.viewModel.selectedPaletteIndex
        } set: { newValue, _ in
            self.viewModel.selectedPaletteIndex = newValue
        }
    }

    init(input: SneakersInput) {
        self.input = input
        self._viewModel = .init(wrappedValue: SneakersViewModel(input: input))
    }
    var body: some View {
        ZStack {
            Color(.init(white: 0.95, alpha: 1))
                .ignoresSafeArea()
            VStack {
                if !viewModel.palettes.isEmpty {
                    TabView(selection: selectedIndexBinding) {
                        ForEach(Array(viewModel.palettes.enumerated()), id: \.element) { value in
                            PaletteView(colors: value.element.allColors, frame: (.init(width: 44, height: 44)))
                                .frame(width: getRect().width * 0.7, height: 40)
                                .tag(value.offset)
                        }
                    }
                    .frame(height: 150)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                }

                Group {
                    if let sneakers = viewModel.sneakers {
                        if !sneakers.isEmpty {
                            PagerView(viewModel: viewModel, showDetail: $showDetails, page: .first())
                                .animation(Animation.spring(), value: viewModel.sneakers)
                                .sheet(isPresented: $showDetails) {
                                    if let sneaker = viewModel.detail {
                                        let colors = viewModel.palettes[viewModel.selectedPaletteIndex].allColors
                                        SneakerDetailView(sneaker: sneaker, colors: colors, viewModel: viewModel)
                                    }
                                }
                        } else {
                            Text("No result")
                                .font(Font.ralewayRegular(size: 32))
                                .opacity(0.3)
                        }
                    } else {
                        UpdateView()
                    }
                }
                .frame(height: getRect().height / 2)
                .sheet(isPresented: $showFilters) {
                    FiltersView(
                        viewModel: .init(
                            filters: self.viewModel.filters ?? Filters(),
                            userFilters: self.$viewModel.userFilters
                        )
                    ) {
                        Task {
                            try? await viewModel.fetchSneakers()
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFilters = true
                } label: {
                    Image("NavBar/filters")
                }.buttonStyle(NavigationButtonStyle())
            }
        }
        .onAppear {
            Task {
                try? await viewModel.fetchFilter()
            }
        }
    }

    private struct PagerView: View {
        let viewModel: SneakersViewModel
        @Binding var showDetail: Bool
        var page: Page

        var body: some View {
            VStack{
                if let sneakers = viewModel.sneakers {
                    Pager(page: page, data: sneakers) { sneaker in
                        LazyImage(source: sneaker.thumbnail) { state in
                            if let image = state.imageContainer?.image {
                                VStack(alignment: .leading, spacing: 5) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding()
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .onTapGesture {
                                            withAnimation(Animation.easeInOut(duration: 0.3)) {
                                                viewModel.detail = sneaker
                                                showDetail = true
                                            }
                                        }
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(sneaker.brand.capitalized)
                                            .font(Font.ralewayMediumItalic(size: 15))
                                        Text(sneaker.name.capitalized)
                                            .font(Font.ralewayBold(size: 20))
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
    }
}
