//
//  UserDefaults.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 27.05.2022.
//

import Foundation

extension UserDefaults {
    func decode<T: Decodable>(_ type: T.Type, forKey defaultName: String) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data(forKey: defaultName) ?? .init())
        } catch {
            let val: [[UInt32]: [SneakerUD]] = [:]
            try self.encode(val, forKey: "favorites")
        }
        return try JSONDecoder().decode(T.self, from: data(forKey: defaultName) ?? .init())
    }
    func encode<T: Encodable>(_ value: T, forKey defaultName: String) throws {
        try set(JSONEncoder().encode(value), forKey: defaultName)
    }
}
