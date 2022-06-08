//
//  FiltersCore.swift
//  Sneakers
//
//  Created by Roman Mazeev on 06/06/22.
//

import Foundation
import SwiftUI

final class FiltersViewModel: ObservableObject {
    struct Filters {
        var genders: [GenericFilterModel<Gender>]
        var brands: [GenericFilterModel<Brand>]
        var sizes: [GenericFilterModel<Size>]
        var priseRange: (min: Double, max: Double)
    }

    private let initialFilters: Filters
    @Published var currentFilters: Filters

    init(initialFilters: Filters) {
        self.initialFilters = initialFilters
        self.currentFilters = initialFilters
    }

    func onExploreTap() {
    }

    func onResetTap() {
        currentFilters = initialFilters
    }

    func onGenericFilterTap<Value>(_ filter: GenericFilterModel<Value>) {
        if let genderValue = filter.value as? Gender {
            guard let genderIndex = currentFilters.genders.firstIndex(where: { $0.value == genderValue }) else {
                return
            }
            currentFilters.genders[genderIndex].isSelected.toggle()
        } else if let brandValue = filter.value as? Brand {
            guard let brandIndex = currentFilters.brands.firstIndex(where: { $0.value == brandValue }) else {
                return
            }
            currentFilters.brands[brandIndex].isSelected.toggle()
        } else if let sizeValue = filter.value as? Size {
            guard let sizeIndex = currentFilters.sizes.firstIndex(where: { $0.value == sizeValue }) else {
                return
            }
            currentFilters.sizes[sizeIndex].isSelected.toggle()
        }
    }
}
