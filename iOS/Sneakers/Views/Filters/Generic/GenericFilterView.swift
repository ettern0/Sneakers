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
        HStack(spacing: spacing) {
            ForEach(filters) { filter in
                Button {
                    guard let filterIndex = filters.firstIndex(where: { $0.id == filter.id }) else { return }
                    filters[filterIndex].isSelected.toggle()
                } label: {
                    content(filter)
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.1), radius: filter.isSelected ? 0 : 12)
                        )
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
            spacing: 0,
            content: { _ in }
        )
    }
}
#endif
