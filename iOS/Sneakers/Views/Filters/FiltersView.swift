//
//  FiltersView.swift
//  Sneakers
//
//  Created by Roman Mazeev on 06/06/22.
//

import SwiftUI
import DesignSystem

struct FiltersView: View {
    enum Filter: String, CaseIterable {
        case gender
        case brands
        case size
        case price
    }

    @State var viewModel: FiltersViewModel

    var body: some View {
        NavigationView {
            VStack {
                ForEach(Filter.allCases, id: \.self) { filter in
                    createFilterView(for: filter)
                }

                Button("Explore") {
                    viewModel.onExploreTap()
                }
                .buttonStyle(LargeButtonStyle())
            }
        }
    }

    private func createFilterView(for filter: Filter) -> some View {
        return HStack {
            Text(filter.rawValue.capitalized)

            switch filter {
            case .gender:
                GenericFilterView(
                    displayedFilters: viewModel.displayedGenders,
                    selectedFilters: $viewModel.selectedFilters.selectedGenders
                ) { filter in
                    Image(filter == .male ? "" : "")
                }
            case .brands:
                GenericFilterView(
                    displayedFilters: viewModel.displayedBrands,
                    selectedFilters: $viewModel.selectedFilters.selectedBrands
                ) { filter in
                    Text(filter.title)
                }
            case .size:
                GenericFilterView(
                    displayedFilters: viewModel.displayedSizes,
                    selectedFilters: $viewModel.selectedFilters.selectedSizes
                ) { filter in
                    Text(filter.displayText)
                }
            case .price:
                EmptyView()
            }
        }
    }
}

#if DEBUG
struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(viewModel: FiltersViewModel.init(selectedFilters: .init()))
    }
}
#endif
