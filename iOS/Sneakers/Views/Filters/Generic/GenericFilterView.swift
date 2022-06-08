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
    private let onFilterTap: (GenericFilterModel<Element>) -> Void

    init(
        filters: Binding<[GenericFilterModel<Element>]>,
        onFilterTap: @escaping (GenericFilterModel<Element>) -> Void,
        spacing: CGFloat,
        @ViewBuilder content: @escaping (GenericFilterModel<Element>) -> Content
    ) {
        self._filters = filters
        self.onFilterTap = onFilterTap
        self.content = content
        self.spacing = spacing
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(filters, id: \.self) { filter in
                content(filter)
                    .padding()
                    .shadow(radius: 20)
                    .border(filter.isSelected ? .accentColor : Color.clear, width: 4)
                    .onTapGesture {
                        onFilterTap(filter)
                    }
            }
        }
    }
}

#if DEBUG
struct GenericFilterView_Previews: PreviewProvider {
    static var previews: some View {
        GenericFilterView(
            filters: .constant([.init(value: Gender.male)]),
            onFilterTap: { _ in },
            spacing: 0,
            content: { _ in }
        )
    }
}
#endif
