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
    struct SliderModel {
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

    static let currency: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 9
            formatter.currencyCode = ""
            formatter.currencySymbol = ""
            return formatter
    }()

    struct GenericFilters {
        var genders: [GenericFilterModel<Gender>]
        var brands: [GenericFilterModel<Brand>]
        var sizes: [GenericFilterModel<Size>]
        var slider: SliderModel
    }

    enum SliderValueType {
        case min
        case max
    }

    @Published var genericFilters: GenericFilters
    var priceRange: (min: Double, max: Double)
    private let filters: Filters

    init(filters: Filters, priceRange: (Double, Double)) {
        self.filters = filters
        self.priceRange = priceRange
        self.genericFilters = .init(genders: [], brands: [], sizes: [], slider: .init(range: 0...0, selectedRange: []))
        self.fillFilters()
    }

    convenience init(filters: Filters) {
        self.init(filters: filters, priceRange: (filters.minPrice, filters.maxPrice))
    }

    func onExploreTap() async throws {
        //try await self.delegate?.fetchSneakers(filter: self)
    }

    func onResetTap() {
        self.fillFilters()
    }

    // TODO: rewrite
    func onReceiveSliderValue(_ value: Double, type: SliderValueType) {
        switch type {
        case .min:
            priceRange.min = value
        case .max:
            priceRange.max = value
        }
    }

    func fillFilters() {
        let filters = self.filters

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            var genders: Set<Gender> = []
            filters.gender.forEach { gender in
                genders.insert(gender == 0 ? .male : .female)
            }

            var sizes: Set<Size> = []
            filters.sizes.forEach { size in
                if let dSize = Double(size) {
                    sizes.insert(.european(dSize))
                }
            }
            var brands: Set<Brand> = []
            filters.brands.forEach { brand in
                brands.insert(Brand(title: brand))
            }

            let _genders = genders.map({ GenericFilterModel(value: $0) })
            let _brands = brands.map({ GenericFilterModel(value: $0) })
            let _sizes = sizes.map({ GenericFilterModel(value: $0) })

            self.priceRange.min = filters.minPrice
            self.priceRange.max = filters.maxPrice
            self.genericFilters = .init(
                genders: _genders,
                brands: _brands,
                sizes: _sizes,
                slider: .init(
                    range: filters.minPrice ... filters.maxPrice,
                    selectedRange: [filters.minPrice, filters.maxPrice]
                )
            )
        }
    }
}
