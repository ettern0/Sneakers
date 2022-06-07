//
//  GenericFilterView.swift
//  Sneakers
//
//  Created by Roman Mazeev on 07/06/22.
//

import SwiftUI

struct GenericFilterView<Element, Content>: View where Content: View, Element: Hashable {
    private let displayedFilters: [Element]
    @Binding private var selectedFilters: [Element]
    private let content: (Element) -> Content

    init(
        displayedFilters: [Element],
        selectedFilters: Binding<[Element]>,
        @ViewBuilder content: @escaping (Element) -> Content
    ) {
        self.displayedFilters = displayedFilters
        self._selectedFilters = selectedFilters
        self.content = content
    }

    var body: some View {
        HStack {
            ForEach(displayedFilters, id: \.self) { filter in
                content(filter)
                    .border(selectedFilters.contains(filter) ? Color.clear : .accentColor, width: 2)
            }
        }
    }
}

#if DEBUG
struct GenericFilterView_Previews: PreviewProvider {
    static var previews: some View {
        GenericFilterView(displayedFilters: [""], selectedFilters: .constant([""])) { i in
            Text(i)
        }
    }
}
#endif
