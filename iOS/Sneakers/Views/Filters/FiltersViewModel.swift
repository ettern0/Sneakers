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

    private struct FilterDTO: Codable {
        var minPrice: Double = 0.0
        var maxPrice: Double = 0.0
        var sizes: [String] = []
        var brands: [String] = []
        var gender: [Int] = []
    }

    private var initialGenericFilters: GenericFilters
    @Published var genericFilters: GenericFilters
    @Published var refreshCompleted: Bool = false
    var priceRange: (min: Double, max: Double)
    var palette: [UInt32]

    init(initialGenericFilters: GenericFilters, priceRange: (Double, Double), palette: [UInt32]) {
        self.initialGenericFilters = initialGenericFilters
        self.genericFilters = initialGenericFilters
        self.priceRange = priceRange
        self.palette = palette
    }

    convenience init(palette: [UInt32]) {
        self.init(initialGenericFilters: .init(genders: Gender.allCases.map { .init(value: $0) }, brands: [], sizes: [], slider: .init(range: 0...0, selectedRange: [])),
                  priceRange: (0, 0), palette: palette)
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

    func fetchFilter() async throws {
        if self.refreshCompleted { return }

        let strPalette = self.palette.map({ String($0) }).joined(separator: ",")
        let urlString = Constants.baseURL + Endpoints.filter + strPalette + ",white"// MARK: delete white, for test

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
