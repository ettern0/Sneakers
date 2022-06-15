//
//  Screen.swift
//  Sneakers
//
//  Created by Alexey Salangin on 12.06.2022.
//

import SwiftUI

enum Screen {
    // Search tab
    case choose
    case camera
    case colorPicker(ColorPickerInput)
    case sneakers(SneakersInput)

    // Favorites tab
    case favorites
}

extension Screen {
    func makeView() -> some View {
        let view: AnyView
        switch self {
        case .choose:
            view = AnyView(ChooseView())
        case .camera:
            view = AnyView(CameraView())
        case .colorPicker(let input):
            view = AnyView(ColorPickerView(input: input))
        case .sneakers(let input):
            view = AnyView(SneakersListView(input: input))
        case .favorites:
            view = AnyView(FavoritesView())
        }

        return ViewHosting(view: view)
    }
}
