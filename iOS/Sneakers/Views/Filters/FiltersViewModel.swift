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
        // try await self.delegate?.fetchSneakers(filter: self)
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

            self.priceRange.min = filters.minPrice
            self.priceRange.max = filters.maxPrice
            self.genericFilters = .init(
                genders: filters.gender.map { GenericFilterModel(value: $0 == 0 ? .male : .female) },
                brands: filters.brands.map { GenericFilterModel(value: .init(title: $0)) },
                sizes: filters.sizes.compactMap {
                    guard let size = Double($0) else { return nil }
                    return GenericFilterModel(value: .european(size))
                },
                slider: .init(
                    range: filters.minPrice ... filters.maxPrice,
                    selectedRange: [filters.minPrice, filters.maxPrice]
                )
            )
        }
    }
}
