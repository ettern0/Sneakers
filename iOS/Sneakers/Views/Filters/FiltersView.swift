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
    @ObservedObject var viewModel: FiltersViewModel
    @StateObject var slider: CustomSlider

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
                        // TODO: Reset Slider
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
                    filters: $viewModel.genericFilters.genders,
                    spacing: 32
                ) { filter in
                    Image(filter.value.imageName)
                }
            case .brands:
                GenericFilterView(
                    filters: $viewModel.genericFilters.brands,
                    spacing: 12
                ) { filter in
                    Text(filter.value.title)
                }
            case .size:
                GenericFilterView(
                    filters: $viewModel.genericFilters.sizes,
                    spacing: 12
                ) { filter in
                    Text(filter.value.displayText)
                }
            case .price:
                VStack(alignment: .leading) {
                    // TODO: Add formatter
                    Text("\(slider.lowHandle.currentValue) - \(slider.highHandle.currentValue)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    RangedSliderView(slider: slider)
                }
            }
        }
        .onChange(of: slider.lowHandle.currentValue) { newValue in
            viewModel.onReceiveSliderValue(newValue, type: .min)
        }
        .onChange(of: slider.highHandle.currentValue) { newValue in
            viewModel.onReceiveSliderValue(newValue, type: .max)
        }
    }
}

#if DEBUG
struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(viewModel: FiltersViewModel.init(
            initialGenericFilters: .init(genders: [], brands: [], sizes: []), priceRange: (0, 100)
        ),
        slider: .init(start: 0, end: 100))
    }
}
#endif
