//
//  Router.swift
//  Sneakers
//
//  Created by Alexey Salangin on 03.06.2022.
//

import Foundation
import SwiftUI
import UIKit

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

enum Tab: CaseIterable {
    case search
    case favorites
}

final class Router: ObservableObject {
    @Published private var currentScreen: Screen = .choose
    @Published private var currentTab: Tab = .search

    private var tabNavigationControllers: [Tab: UINavigationController] = [:]

    func tabBarViewControllers() -> [UIViewController] {
        Tab.allCases.map(viewController(for:))
    }

    func push(screen: Screen) {
        let nextView = makeView(for: screen)
        let hostingController = UIHostingController(rootView: nextView)
        hostingController.hidesBottomBarWhenPushed = true
        let currentRootController = self.viewController(for: currentTab)
        currentRootController.pushViewController(hostingController, animated: true)
    }

    private func makeView(for screen: Screen) -> AnyView {
        let view = screen
            .makeView()
            .environmentObject(self)
        return AnyView(view)
    }

    private func viewController(for tab: Tab) -> UINavigationController {
        let viewController = tabNavigationControllers[tab] ?? makeNavigationController(for: tab)
        return viewController
    }

    private func makeNavigationController(for tab: Tab) -> UINavigationController {
        switch tab {
        case .search:
            let view = makeView(for: .choose)
            let searchViewController = UIHostingController<AnyView>(rootView: view)
            let searchNavigationController = UINavigationController(rootViewController: searchViewController)
            searchNavigationController.tabBarItem = UITabBarItem(
                title: "Search",
                image: UIImage(systemName: "magnifyingglass"),
                selectedImage: UIImage(systemName: "magnifyingglass")
            )
            tabNavigationControllers[tab] = searchNavigationController
            return searchNavigationController
        case .favorites:
            let favoritesViewController = UIHostingController<AnyView>(
                rootView: AnyView(FavoritesView())
            )
            let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
            favoritesNavigationController.tabBarItem = UITabBarItem(
                title: "Favorites",
                image: UIImage(systemName: "heart"),
                selectedImage: UIImage(systemName: "heart")
            )
            tabNavigationControllers[tab] = favoritesNavigationController
            return favoritesNavigationController
        }
    }
 }
