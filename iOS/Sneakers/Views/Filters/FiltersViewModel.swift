//
//  FiltersCore.swift
//  Sneakers
//
//  Created by Roman Mazeev on 06/06/22.
//

import Foundation
import SwiftUI
import SneakerModels

final class FiltersViewModel: ObservableObject {
    struct SliderModel: Equatable {
        var labelText: String {
            guard let first = selectedRange.first, let second = selectedRange.last else { return "" }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.minimumFractionDigits = 2
            if let first = numberFormatter.string(from: NSNumber(value: first)),
               let second = numberFormatter.string(from: NSNumber(value: second)) {
                let result = ("\(first) - \(second)")
                return (result)
            }
            return ""
        }

        var range: ClosedRange<CGFloat>
        var selectedRange: [CGFloat]
    }

    struct GenericFilters {
        var genders: [GenericFilterModel<Gender>]
        var brands: [GenericFilterModel<Brand>]
        var sizes: [GenericFilterModel<Size>]
        var slider: SliderModel

        var filters: Filters {
            Filters(
                minPrice: slider.selectedRange[0],
                maxPrice: slider.selectedRange[1],
                sizes: sizes.filter(\.isSelected).map(\.value.rawValue),
                brands: brands.filter(\.isSelected).map(\.value.title),
                gender: genders.filter(\.isSelected).map(\.value.rawValue)
            )
        }
    }

    enum SliderValueType {
        case min
        case max
    }

    @Published var genericFilters: GenericFilters
    @Binding var userFilters: Filters?
    private let filters: Filters

    init(filters: Filters, userFilters: Binding<Filters?>) {
        self._userFilters = userFilters
        self.filters = filters
        self.genericFilters = .init(genders: [], brands: [], sizes: [], slider: .init(range: 0...1, selectedRange: []))
        self.fillFilters()
    }

    func onExploreTap() async throws {
        self.userFilters = genericFilters.filters
    }

    func onResetTap() {
        self.userFilters = .init(minPrice: self.filters.minPrice, maxPrice: self.filters.maxPrice, sizes: [], brands: [], gender: [])
        self.fillFilters()
    }

    func fillFilters() {
        let filters = self.filters

        let selectedGenders = Set(self.userFilters?.gender ?? [])
        let selectedBrands = Set(self.userFilters?.brands ?? [])
        let selectedSizes = Set(self.userFilters?.sizes ?? [])
        let selectedRange = [self.userFilters?.minPrice ?? filters.minPrice, self.userFilters?.maxPrice ?? filters.maxPrice]

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.genericFilters = .init(
                genders: filters.gender.map {
                    GenericFilterModel(value: $0 == 0 ? .male : .female, isSelected: selectedGenders.contains($0))
                },
                brands: filters.brands.map {
                    GenericFilterModel(value: .init(title: $0), isSelected: selectedBrands.contains($0))
                },
                sizes: filters.sizes.compactMap {
                    guard let size = Double($0) else { return nil }
                    return GenericFilterModel(value: .european(size), isSelected: selectedSizes.contains($0))
                },
                slider: .init(
                    range: filters.minPrice ... filters.maxPrice,
                    selectedRange: selectedRange.map { CGFloat($0) }
                )
            )
        }
    }
}
