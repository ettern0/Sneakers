//
//  Router.swift
//  Sneakers
//
//  Created by Alexey Salangin on 03.06.2022.
//

import Foundation
import SwiftUI

enum Screen {
    case choose
    case camera
    case sneakers
}

extension Screen {
    fileprivate func makeView() -> some View {
        switch self {
        case .choose:
            return AnyView(ChooseView())
        case .camera:
            return AnyView(CameraView())
        case .sneakers:
            return AnyView(SneakersListView())
        }
    }
}

final class Router: ObservableObject {
    @Published var currentScreen: Screen = .choose

    func makeView(for screen: Screen) -> some View {
        let view = screen
            .makeView()
            .environmentObject(self)
        return view
    }
 }
