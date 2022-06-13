//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 13.06.2022.
//

import Foundation

public struct UserFilters: Codable {
    public let filters: Filters
    public let colors: [UInt32]
}
