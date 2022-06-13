//
//  FavoritesView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 27.05.2022.
//

import SwiftUI

struct FavoritesView: View {

    @State var palletes: [PaletteViewModel] = []
    @State var data: [[UInt32]: [SneakerUD]] = [:]
    @State var selectedType: Int = 0
    @State var searchText: String = ""

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text("")
                    .searchable(text: $searchText, prompt: "Search")
                Picker("Choose type", selection: $selectedType) {
                    Text("Sneakers").tag(0)
                    Text("Outfit").tag(1)
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            ScrollView {
                ForEach(palletes.indices, id: \.self) { index in
                    if let sneakers = data[palletes[index].key], !sneakers.isEmpty {
                        SneakerView(sneakers: sneakers.filter({ checkSearchForSneaker($0, searchText) }), pallete: palletes[index])
                            .padding(.bottom, 24)
                    }
                }
            }
            .padding(.horizontal, 16)
        }.onAppear {
            data = fetchDataFromUD()
            data.keys.forEach { key in
                palletes.append(PaletteViewModel(colors: key))
            }
        }
    }

    func checkSearchForSneaker(_ sneaker: SneakerUD, _ searchStr: String) -> Bool {
        let searchUpper = searchStr.uppercased()
        return sneaker.brand.uppercased().contains(searchUpper) ||
        sneaker.name.uppercased().contains(searchUpper) ||
        searchText.isEmpty
    }

    private struct SneakerView: View {
        let sneakers: [SneakerUD]
        let pallete: PaletteViewModel
        @State var showDetails: Bool = false
        @State var viewModel: SneakersViewModel = SneakersViewModel(input: SneakersInput(outfitColors: []))

        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sneakers) { sneaker in
                        VStack {
                            PaletteView(viewModel: pallete)
                                .frame(maxWidth: 100, maxHeight: 100)
                            let url = URL(string: sneaker.thumbnail)
                            AsyncImage(
                                url: url,
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                }, placeholder: { ProgressView() }
                            )
                            VStack(alignment: .leading) {
                                Text(sneaker.brand.capitalized).font(.system(size: 10)).italic()
                                Text(sneaker.name.capitalized).font(.system(size: 12)).bold()
                            }
                            .frame(maxWidth: 100, maxHeight: 100)
                        }
                        .sheet(isPresented: $showDetails) {
                            if let _sneaker = viewModel.detail {
                                SneakerDetailView(sneaker: _sneaker, input: SneakersInput(outfitColors: []), viewModel: viewModel)
                            }
                        }
                        .onTapGesture {
                            Task {

                                    try await viewModel.fetchSneakers(id: sneaker.id)
                                    for index in 0..<viewModel.sneakers.count {
                                        self.viewModel.detail = viewModel.sneakers[index]
                                        showDetails = true
                                        break
                                    }

                            }
                        }
                    }
                }
            }
        }
    }

    func fetchDataFromUD() -> [[UInt32]: [SneakerUD]] {
        do {
            let defaults = UserDefaults.standard
            return try defaults.decode([[UInt32]: [SneakerUD]].self, forKey: "favorites")
        } catch {
            return [:]
        }
    }
}
