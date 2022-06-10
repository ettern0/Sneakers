//
//  FiltersView.swift
//  Sneakers
//
//  Created by Roman Mazeev on 06/06/22.
//

import SwiftUI
import DesignSystem
import MultiSlider

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
            if viewModel.refreshCompleted {
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
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchFilter()
                } catch {
                    assertionFailure("can't init filters")
                }
            }
        }
    }

    private func createFilterView(for filter: Filter) -> some View {
        return VStack(alignment: .leading) {
            Text(filter.rawValue.capitalized)
                .font(.headline)
                .padding(.bottom, 4)

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
                    Text(viewModel.genericFilters.slider.labelText)
                        .foregroundColor(.black.opacity(0.5))
                    MultiValueSlider(
                        value: $viewModel.genericFilters.slider.selectedRange,
                        minimumValue: viewModel.genericFilters.slider.range.lowerBound,
                        maximumValue: viewModel.genericFilters.slider.range.upperBound,
                        isHapticSnap: true,
                        orientation: .horizontal,
                        outerTrackColor: .lightGray,
                        valueLabelColor: .lightGray,
                        valueLabelFont: .boldSystemFont(ofSize: 12)
                     )
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
