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

    @Environment(\.presentationMode) var presentationMode
    @State var viewModel: FiltersViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(Filter.allCases, id: \.self) { filter in
                            createFilterView(for: filter)
                        }
                    }
                    .padding()
                }

                Spacer()

                Button("Explore") {
                    viewModel.onExploreTap()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(LargeButtonStyle())
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Filter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        viewModel.onResetTap()
                    }
                }
            }
        }
    }

    private func createFilterView(for filter: Filter) -> some View {
        return VStack(alignment: .leading) {
            Text(filter.rawValue.capitalized)
                .font(.headline)

            switch filter {
            case .gender:
                GenericFilterView(
                    filters: $viewModel.currentFilters.genders,
                    onFilterTap: viewModel.onGenericFilterTap,
                    spacing: 32
                ) { filter in
                    Image(filter.value.imageName)
                }
            case .brands:
                GenericFilterView(
                    filters: $viewModel.currentFilters.brands,
                    onFilterTap: viewModel.onGenericFilterTap,
                    spacing: 12
                ) { filter in
                    Text(filter.value.title)
                }
            case .size:
                GenericFilterView(
                    filters: $viewModel.currentFilters.sizes,
                    onFilterTap: viewModel.onGenericFilterTap,
                    spacing: 12
                ) { filter in
                    Text(filter.value.displayText)
                }
            case .price:
                HStack {
                    // TODO: Add formatter
                    Text("\(viewModel.currentFilters.priseRange.min) - \(viewModel.currentFilters.priseRange.max)")
                        .font(.subheadline)
                }
            }
        }
    }
}

#if DEBUG
struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(viewModel: FiltersViewModel.init(
            initialFilters: .init(genders: [], brands: [], sizes: [], priseRange: (0, 100))
        ))
    }
}
#endif
