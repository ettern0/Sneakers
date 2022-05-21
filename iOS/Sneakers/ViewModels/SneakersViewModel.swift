//
//  SneakersListViewModel.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation

final class SneakersViewModel: ObservableObject {

    static let instance = SneakersViewModel()

    @Published var sneakers: [Sneaker] = []
    @Published var active: Int = 0
    @Published var drag: Float = 0.0
    @Published var detail: Sneaker?
    @Published var showDetail: Bool = false

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
}
