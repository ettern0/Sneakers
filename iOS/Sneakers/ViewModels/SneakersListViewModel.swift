//
//  SneakersListViewModel.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation

final class SneakersListViewModel: ObservableObject {
    @Published var sneakers: [Sneaker] = []

    func fetchSneakers() async throws {
        let urlString = Constants.baseURL + Endpoints.portion

        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }

        let sneakerResponse : [Sneaker] = try await HttpClient.shared.fetch(url: url)

        DispatchQueue.main.async {
            self.sneakers = sneakerResponse
        }
    }
}
