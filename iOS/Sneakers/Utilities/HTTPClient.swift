//
//  HTTPClient.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation

enum HTTPError: Error {
    case badResponse, invalidDataFormat
}

final class HTTPClient {
    private init() {}

    static let shared = HTTPClient()

    func fetch<T: Codable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HTTPError.badResponse
        }

        guard let object = try? JSONDecoder().decode(T.self, from: data) else {
            throw HTTPError.invalidDataFormat
        }
        return object
    }
}
