//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 05.05.2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    public func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate? = nil
    ) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, URLResponse), Error>) in
            let task = self.dataTask(with: request) { data, response, error in
                if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    assertionFailure("Impossible")
                    struct FakeError: Error {}
                    continuation.resume(throwing: FakeError())
                }
            }
            task.resume()
        }
    }
}
