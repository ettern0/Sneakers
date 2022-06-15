//
//  SneakerDescriptionView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//
import Foundation
import SwiftUI

struct SneakerDescriptionView: View {
    let sneaker: Sneaker
    let viewModel: SneakersViewModel
    let colors: [UInt32]
    @State var isFavorite: Bool = false

    init(viewModel: SneakersViewModel, sneaker: Sneaker, colors: [UInt32]) {
        self.viewModel = viewModel
        self.sneaker = sneaker
        self.colors = colors
        self._isFavorite = State(initialValue: checkStatusUD(colors: colors))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(sneaker.brand.capitalized)
                .font(Font.ralewayMediumItalic(size: 18))
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(sneaker.name.capitalized)
                        .font(Font.ralewayBold(size: 22))
                    if let min = sneaker.minPrice, let max = sneaker.maxPrice {
                        Text("Price range: \(priceFormat(min))  - \(priceFormat(max))")
                            .font(Font.ralewaySemiBold(size: 13))
                            .padding(.bottom, 36)
                            .opacity(0.5)
                    }
                }
                Spacer()
                Button {
                    changeStatusUD(colors: colors)
                } label: {
                    LikeButtonView(isFavorite: isFavorite)
                }
            }
            if !sneaker.description.isEmpty {
                Text("Description".capitalized)
                    .font(Font.ralewayBold(size: 18))
                    .padding(.bottom, 10)
                Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: ""))
                    .font(Font.ralewayRegular(size: 16))
                    .padding(.bottom, 36)
            }
            Text("Marketplace".capitalized)
                .font(Font.ralewayBold(size: 18))
                .padding(.bottom, 10)
            // MARK: TODO Fetch marketplaces from backend
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    MarketButtonView(market: "StockX", strURL: sneaker.resellLinkStockX)
                    MarketButtonView(market: "Goods", strURL: "https://www.stadiumgoods.com")
                    MarketButtonView(market: "Goat", strURL: "https://www.goat.com")
                }
            }
        }
        .padding()
        .background(Color.white)
    }

    private struct MarketButtonView: View {
        @Environment(\.openURL) var openURL
        let market: String
        let strURL: String

        var body: some View {
            Button {
                if let url = URL(string: strURL.replacingOccurrences(of: "'", with: "")) {
                    openURL(url)
                }
            } label: {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .frame(width: 60, height: 32)
                    .foregroundColor(.black.opacity(0.03))
                    .overlay {
                        Text(market)
                            .font(Font.ralewayMedium(size: 14))
                            .foregroundColor(.black)
                    }
            }
        }
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

    private func changeStatusUD(colors: [UInt32]) {
        let defaults = UserDefaults.standard

        do {
            var favorites = try defaults.decode([[UInt32]: [SneakerUD]].self, forKey: "favorites")
            if var collection = favorites[colors] {
                if isFavorite {
                    collection.removeAll(where: { $0.id == sneaker.id })
                } else {
                    collection.append(SneakerUD(from: sneaker))
                }
                favorites[colors] = collection
            } else if !isFavorite {
                favorites[colors] = [SneakerUD(from: sneaker)]
            }
            try defaults.encode(favorites, forKey: "favorites")
            isFavorite.toggle()
        } catch {
            assertionFailure(String(describing: error))
        }
    }

    private func checkStatusUD(colors: [UInt32]) -> Bool {
        do {
            let defaults = UserDefaults.standard
            let favorites = try defaults.decode([[UInt32]: [SneakerUD]].self, forKey: "favorites")
            if let collection = favorites[colors] {
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

func priceFormat(_ from: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.minimumFractionDigits = 2
    if let digit = numberFormatter.string(from: NSNumber(value: from)) {
        return digit
    }
    return ""
}
