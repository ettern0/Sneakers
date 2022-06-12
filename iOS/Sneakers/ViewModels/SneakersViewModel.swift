//
//  SneakersListViewModel.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation
import SneakerModels

final class SneakersViewModel: ObservableObject {

    @Published var sneakers: [Sneaker] = []
    @Published var active: Int = 0
    @Published var drag: Float = 0.0
    @Published var detail: Sneaker?
    let input: SneakersInput

    init(input: SneakersInput) {
        self.input = input
    }

    func fetchSneakers(filter: FiltersViewModel? = nil) async throws {
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
    }
}
