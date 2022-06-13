//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 14.06.2022.
//

import Foundation
import SneakerModels
import Vapor

struct UserFitersRequestData: Content {
  let userFilters: UserFilters
}
