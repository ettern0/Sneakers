//
//  FavoritesView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 27.05.2022.
//

import SwiftUI

struct FavoritesView: View {

    var palletes: [PaletteViewModel] = []
    var data: [[UInt32]: [SneakerUD]] = [:]

    init() {
        self.data = fetchDataFromUD()
        self.data.keys.forEach { key in
            self.palletes.append(PaletteViewModel(colors: key))
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    Text("Preferences").font(.system(size: 40)).bold()
                    Text("Here’s your favourite match!").font(.system(size: 20)).foregroundColor(.black).opacity(0.2)
                }
                .padding(.bottom, 36)
                .padding(.top)
                ForEach(palletes.indices) { index in
                    if let sneakers = data[palletes[index].key], !sneakers.isEmpty {
                        Section(header: PaletteView(viewModel: palletes[index]).frame(height: 32)) {
                            SneakerView(sneakers: sneakers)
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private struct SneakerView: View {
        let sneakers: [SneakerUD]

        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sneakers) { sneaker in
                        let url = URL(string: sneaker.thumbnail)
                        AsyncImage(
                            url: url,
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 100, maxHeight: 100)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
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
