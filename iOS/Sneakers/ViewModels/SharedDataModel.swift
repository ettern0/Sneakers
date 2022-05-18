//
//  SharedDataModel.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import Foundation

class SharedDataModel: ObservableObject {
    @Published var detail: Sneaker?
    @Published var showDetailProduct: Bool = false
}
