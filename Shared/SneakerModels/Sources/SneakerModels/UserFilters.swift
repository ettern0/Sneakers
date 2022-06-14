//
//  UserFilters.swift
//  
//
//  Created by Evgeny Serdyukov on 13.06.2022.
//

import Foundation

public struct UserFilters: Codable {
    public let filters: Filters
    public let colors: [UInt32]

    public init(filters: Filters, colors: [UInt32]) {
        self.filters = filters
        self.colors = colors
    }
}
