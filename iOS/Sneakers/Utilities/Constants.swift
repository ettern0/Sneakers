//
//  Constants.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation

enum Constants {
    static let baseURL = "https://vapor-sneakers.herokuapp.com/"
    // static let baseURL = "http://127.0.0.1:8080/"
}

enum Endpoints {
    static let all = "sneakers/all"
    static let portion = "sneakers/portion/20"
    static let portionID = "sneakers/portion/?id="
    static let filter = "sneakers/filters/palette?palette="
}
