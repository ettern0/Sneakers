//
//  SneakersListViewModel.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation
import SneakerModels
import SwiftUI
import Combine

final class SneakersViewModel: ObservableObject {
    @Published var sneakers: [Sneaker] = []
    @Published var selectedPaletteIndex: Int = 0
    private var filtersResponse: FiltersResponse? = nil
    @Published var palettes: [ColorPalette] = []
    @Published var filters: Filters? = nil
    @Published var active: Int = 0
    @Published var drag: Float = 0.0
    @Published var detail: Sneaker?
    private let input: SneakersInput
    private var cancelBag: Set<AnyCancellable> = []

    init(input: SneakersInput) {
        self.input = input

        $selectedPaletteIndex.sink { [weak self] _ in
            guard let self = self else { return }
            Task {
                try? await self.fetchSneakers()
            }
        }.store(in: &cancelBag)
    }

    func fetchSneakers() async throws {
        let urlString = Constants.baseURL + Endpoints.portion

        guard let url = URL(string: urlString) else {
            self.sneakers = []
            return assertionFailure("Invalid URL.")
        }
        let sneakerResponse: [Sneaker] = try await HTTPClient.shared.fetch(url: url)
        DispatchQueue.main.async {
            self.sneakers = sneakerResponse
        }
    }

    func fetchFilter() async throws {
        let strPalette = self.input.outfitColors.map({ String($0) }).joined(separator: ",")
        let urlString = Constants.baseURL + Endpoints.filter + strPalette

        guard let url = URL(string: urlString) else {
            return assertionFailure("Invalid URL.")
        }

        let response: FiltersResponse = try await HTTPClient.shared.fetch(url: url)

        await MainActor.run {
            self.filters = response.filters
            self.palettes = response.palettes
        }

        try await self.fetchSneakers()
    }
}
