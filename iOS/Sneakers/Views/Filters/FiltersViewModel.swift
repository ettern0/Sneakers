//
//  FiltersCore.swift
//  Sneakers
//
//  Created by Roman Mazeev on 06/06/22.
//

import Foundation

final class FiltersViewModel: ObservableObject {
    let displayedGenders: [Gender] = []
    let displayedBrands: [Brand] = []
    let displayedSizes: [Size] = []

    struct SelectedFilters {
        var selectedGenders: [Gender]
        var selectedBrands: [Brand]
        var selectedSizes: [Size]
        var selectedPrizeRange: (min: Double, max: Double)

        init() {
            self.selectedGenders = []
            self.selectedBrands = []
            self.selectedSizes = []
            self.selectedPrizeRange = (0.0, 0.0)
        }
    }

    @Published var selectedFilters: SelectedFilters

    init(selectedFilters: SelectedFilters) {
        self.selectedFilters = selectedFilters
    }

    func onExploreTap() {
        
    }
}
