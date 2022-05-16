//
//  ContentView.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI

struct SneakersList: View {

    @StateObject var viewModel = SneakersListViewModel()

    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.sneakers) { sneaker in
                        Button {
                            print("test")
                        } label: {
                            AsyncImage(url: URL(string: sneaker.thumbnail)) { image in
                                image
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                }
                .navigationTitle(Text("Collections of sneakers"))
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
}
