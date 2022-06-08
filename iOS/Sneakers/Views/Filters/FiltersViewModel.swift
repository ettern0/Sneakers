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
}
