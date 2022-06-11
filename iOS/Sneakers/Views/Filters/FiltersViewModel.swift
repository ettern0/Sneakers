//
//  FiltersCore.swift
//  Sneakers
//
//  Created by Roman Mazeev on 06/06/22.
//

import Foundation
import SwiftUI

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

    private var initialGenericFilters: GenericFilters
    @Published var genericFilters: GenericFilters
    @Published var refreshCompleted: Bool = false
    var priceRange: (min: Double, max: Double)

    init(initialGenericFilters: GenericFilters, priceRange: (Double, Double)) {
        self.initialGenericFilters = initialGenericFilters
        self.genericFilters = initialGenericFilters
        self.priceRange = priceRange
    }

    convenience init(filters: FilterDTO) {
        let initSlider: SliderModel = .init(range: filters.minPrice...filters.maxPrice, selectedRange: [])
        var genders: Set<Gender> = []
        filters.gender.forEach { gender in
            genders.insert(gender == 0 ? .male : .female)
        }
        let _genders = genders.map({ GenericFilterModel(value: $0) })
        let initialFilter: GenericFilters = .init(genders: _genders, brands: [], sizes: [], slider: initSlider)
        self.init(initialGenericFilters: initialFilter, priceRange: (filters.minPrice, filters.maxPrice))
    }

    func onExploreTap() async throws {
        //try await self.delegate?.fetchSneakers(filter: self)
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

    func fetchFilter() async throws {
        if self.refreshCompleted { return }

       // let strPalette = self.palette.map({ String($0) }).joined(separator: ",")
        let urlString = Constants.baseURL + Endpoints.filter //+ strPalette

        guard let url = URL(string: urlString) else {
            return assertionFailure("Invalid URL.")
        }

        let response: FilterDTO = try await HTTPClient.shared.fetch(url: url)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            var genders: Set<Gender> = []
            response.gender.forEach { gender in
                genders.insert(gender == 0 ? .male : .female)
            }

            var sizes: Set<Size> = []
            response.sizes.forEach { size in
                if let dSize = Double(size) {
                    sizes.insert(.european(dSize))
                }
            }
            var brands: Set<Brand> = []
            response.brands.forEach { brand in
                brands.insert(Brand(title: brand))
            }

            let _genders = genders.map({ GenericFilterModel(value: $0) })
            let _brands = brands.map({ GenericFilterModel(value: $0) })
            let _sizes = sizes.map({ GenericFilterModel(value: $0) })
            self.initialGenericFilters = .init(
                genders: _genders,
                brands: _brands,
                sizes: _sizes,
                slider: .init(
                    range: response.minPrice ... response.maxPrice,
                    selectedRange: [response.minPrice, response.maxPrice]
                )
            )
            self.priceRange.min = response.minPrice
            self.priceRange.max = response.maxPrice
            self.genericFilters = self.initialGenericFilters
            self.refreshCompleted = true
        }
    }
}
