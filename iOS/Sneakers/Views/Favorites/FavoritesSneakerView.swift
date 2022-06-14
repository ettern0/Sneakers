//
//  SneakerView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 15.06.2022.
//

import SwiftUI

struct FavoritesSneakerView: View {
    let sneakers: [SneakerUD]
    let colors: [UInt32]
    @State var showDetails: Bool = false
    @State var viewModel: SneakersViewModel = SneakersViewModel(input: SneakersInput(outfitColors: []))

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(sneakers) { sneaker in
                    VStack {
                        paletteView
                        ThumbNailView(thumbnail: sneaker.thumbnail)

                        VStack(alignment: .leading) {
                            Text(sneaker.brand.capitalized).font(.system(size: 10)).italic()
                            Text(sneaker.name.capitalized).font(.system(size: 12)).bold()
                        }
                        .frame(maxWidth: 100, maxHeight: 100)
                    }
                    .sheet(isPresented: $showDetails) {
                        if let _sneaker = viewModel.detail {
                            SneakerDetailView(sneaker: _sneaker, colors: colors, viewModel: viewModel)
                        }
                    }
                    .frame(width: 140, height: 200)
                    .shadow(color: .black, radius: 5)
                    .onTapGesture {
                        Task {
                            try await viewModel.fetchSneakers(id: sneaker.id)
                            if let sneakers = viewModel.sneakers {
                                for index in 0..<(viewModel.sneakers?.count ?? 0) {
                                    self.viewModel.detail = sneakers[index]
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

    var paletteView: some View {
        PaletteView(colors: colors, frame: (.init(width: 24, height: 24)))
            .frame(maxWidth: 100, maxHeight: 100)
    }

    var descriptionView: some View {
        
    }


}
