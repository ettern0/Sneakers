//
//  HTTPClient.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation

enum HttpError: Error {
    case badURL, badResponse, errorDecodeingData, invalidURL
}

class HttpClient {
    private init() {}
    static let shared = HttpClient()

    func fetch<T: Codable>(url: URL) async throws ->[T] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }

        guard let object = try? JSONDecoder().decode([T].self, from: data) else {
            throw HttpError.errorDecodeingData
        }
        return object
    }
}
