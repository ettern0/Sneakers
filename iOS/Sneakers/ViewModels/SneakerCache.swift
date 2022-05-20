//
//  SneakerCache.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 18.05.2022.
//

import Foundation

final class SneakerCache {
    static let shared = SneakerCache()
    var map: [AnyHashable: Int] = [:]
}
