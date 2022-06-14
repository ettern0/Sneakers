//
//  FavoritesView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 27.05.2022.
//

import SwiftUI

struct FavoritesView: View {

    @State var colors: [[UInt32]] = []
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
            if selectedType == 0 {
                ScrollView {
                    ForEach(colors.indices, id: \.self) { index in
                        if let sneakers = data[colors[index]], !sneakers.isEmpty {
                            let palette = colors[index]
                            FavoritesSneakerView(sneakers: sneakers.filter({ checkSearchForSneaker($0, searchText) }), colors: palette)
                                .padding(.bottom, 24)
                        }
                    }
                }
                .padding(.horizontal, 16)
            } else {
                Spacer()
            }
        }.onAppear {
            data = fetchDataFromUD()
            data.keys.forEach { palette in
                colors.append(palette)
            }
        }
    }

    private func checkSearchForSneaker(_ sneaker: SneakerUD, _ searchStr: String) -> Bool {
        let searchUpper = searchStr.uppercased()
        return sneaker.brand.uppercased().contains(searchUpper) ||
        sneaker.name.uppercased().contains(searchUpper) ||
        searchText.isEmpty
    }

    private func fetchDataFromUD() -> [[UInt32]: [SneakerUD]] {
        do {
            let defaults = UserDefaults.standard
            return try defaults.decode([[UInt32]: [SneakerUD]].self, forKey: "favorites")
        } catch {
            return [:]
        }
    }
}
