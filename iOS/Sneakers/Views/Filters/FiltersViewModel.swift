//
//  FiltersCore.swift
//  Sneakers
//
//  Created by Roman Mazeev on 06/06/22.
//

import Foundation
import SwiftUI

final class FiltersViewModel: ObservableObject {
    struct GenericFilters {
        var genders: [GenericFilterModel<Gender>]
        var brands: [GenericFilterModel<Brand>]
        var sizes: [GenericFilterModel<Size>]
    }

    enum SliderValueType {
        case min
        case max
    }

    private let initialGenericFilters: GenericFilters
    @Published var genericFilters: GenericFilters
    var priceRange: (min: Double, max: Double)

    init(initialGenericFilters: GenericFilters, priceRange: (Double, Double)) {
        self.initialGenericFilters = initialGenericFilters
        self.genericFilters = initialGenericFilters
        self.priceRange = priceRange
    }

    func onExploreTap() {
    }

    func onResetTap() {
        genericFilters = initialGenericFilters
    }

    func onReceiveSliderValue(_ value: Double, type: SliderValueType) {
        switch type {
        case .min:
            priceRange.min = value
        case .max:
            priceRange.max = value
        }
    }
}
