//
//  SneakerDescriptionView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//

import SwiftUI

struct SneakerDescriptionView: View {
    let sneaker: Sneaker
    let input: SneakersInput
    @StateObject var viewModel: SneakersViewModel = SneakersViewModel.instance
    @State var isFavorite: Bool = false

    init(sneaker: Sneaker, input: SneakersInput) {
        self.sneaker = sneaker
        self.input = input
        self._isFavorite = State(initialValue: checkStatusUD())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(sneaker.brand.capitalized).font(.system(size: 17)).opacity(0.8)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(sneaker.name.capitalized).font(.system(size: 22)).bold()
                    Text("Price range: 120.000$  - 180.000$").font(.system(size: 12)).italic().padding(.bottom, 15).opacity(0.5)
                }
                Spacer()
                Button {
                    changeStatusUD()
                } label: {
                    LikeButtonView(isFavorite: isFavorite)
                }
            }
            Text("Description".capitalized).font(.system(size: 15)).bold().padding(.bottom, 10)
            Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: "")).font(.system(size: 12))
            Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: "")).font(.system(size: 12))
        }
        .padding()
        .background(Color.white)
    }

    private struct LikeButtonView: View {
        let isFavorite: Bool
        var body: some View {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.red)
                    .padding(.bottom)
            } else {
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.red)
                    .padding(.bottom)
            }
        }
    }

    private func changeStatusUD() {
        let defaults = UserDefaults.standard
        let palette = PaletteViewModel.instance

        do {
            var favorites = try defaults.decode([[UInt32]: [SneakerUD]].self, forKey: "favorites")
            if var collection = favorites[palette.key] {
                if isFavorite {
                    collection.removeAll(where: { $0.id == sneaker.id })
                } else {
                    collection.append(SneakerUD(from: sneaker))
                }
                favorites[palette.key] = collection
            } else if !isFavorite {
                favorites[palette.key] = [SneakerUD(from: sneaker)]
            }
            try defaults.encode(favorites, forKey: "favorites")
            isFavorite.toggle()
        } catch {
            assertionFailure(String(describing: error))
        }
    }

    private func checkStatusUD() -> Bool {
        do {
            let defaults = UserDefaults.standard
            let favorites = try defaults.decode([[UInt32]: [SneakerUD]].self, forKey: "favorites")
            let palette = PaletteViewModel.instance
            if let collection = favorites[palette.key] {
                if collection.contains(where: { $0.id == sneaker.id }) {
                    return true
                }
            }
            return false
        } catch {
            return false
        }
    }

}
