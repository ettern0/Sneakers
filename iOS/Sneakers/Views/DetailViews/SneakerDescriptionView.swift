//
//  SneakerDescriptionView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//

import SwiftUI

struct SneakerDescriptionView: View {
    let sneaker: Sneaker
    @StateObject var viewModel: SneakersViewModel = SneakersViewModel.instance

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(sneaker.brand.capitalized).font(.title3).opacity(0.8)
            Text(sneaker.name.capitalized).font(.largeTitle).bold()
            Text("Price range: 120.000$  - 180.000$").italic().padding(.bottom, 15).opacity(0.5)
            Text("Description".capitalized).font(.title3).bold().padding(.bottom, 10)
            Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: "")).bold()
            Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: "")).bold()
            Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: "")).bold()
        }
        .padding()
        .background(Color.white)
    }
}
