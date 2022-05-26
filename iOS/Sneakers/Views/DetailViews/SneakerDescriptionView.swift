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
            Text(sneaker.brand.capitalized).font(.system(size: 17)).opacity(0.8)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(sneaker.name.capitalized).font(.system(size: 22)).bold()
                    Text("Price range: 120.000$  - 180.000$").font(.system(size: 12)).italic().padding(.bottom, 15).opacity(0.5)
                }
                Spacer()
                Button {

                } label: {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.red)
                        .padding(.bottom)
                }
            }
            Text("Description".capitalized).font(.system(size: 15)).bold().padding(.bottom, 10)
            Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: "")).font(.system(size: 12))
            Text(sneaker.description.capitalized.replacingOccurrences(of: "<Br>", with: "")).font(.system(size: 12))
        }
        .padding()
        .background(Color.white)
    }
}
