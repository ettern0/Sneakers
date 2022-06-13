//
//  GenericFilterView.swift
//  Sneakers
//
//  Created by Roman Mazeev on 07/06/22.
//

import SwiftUI

struct GenericFilterView<Element, Content>: View where Content: View, Element: Hashable {
    @Binding private var filters: [GenericFilterModel<Element>]
    private let content: (GenericFilterModel<Element>) -> Content
    private let spacing: CGFloat

    init(
        filters: Binding<[GenericFilterModel<Element>]>,
        spacing: CGFloat,
        @ViewBuilder content: @escaping (GenericFilterModel<Element>) -> Content
    ) {
        self._filters = filters
        self.content = content
        self.spacing = spacing
    }

    var body: some View {
        FlexibleView(
            data: filters,
            spacing: spacing,
            alignment: .leading
        ) { filter in
            content(filter)
                .foregroundColor(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 6)
                      .foregroundColor(.white)
                      .shadow(color: .black.opacity(0.1), radius: filter.isSelected ? 0 : 12)
                      .border(filter.isSelected ? .black : .clear, width: 2)
            )
            .onTapGesture {
                guard let filterIndex = filters.firstIndex(of: filter) else { return }
                filters[filterIndex].isSelected.toggle()
            }
        }
    }
}

#if DEBUG
struct GenericFilterView_Previews: PreviewProvider {
    static var previews: some View {
        GenericFilterView(
            filters: .constant([.init(value: Gender.male)]),
            spacing: 0,
            content: { _ in }
        )
    }
}
#endif
