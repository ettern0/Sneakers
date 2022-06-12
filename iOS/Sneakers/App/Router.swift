//
//  Router.swift
//  Sneakers
//
//  Created by Alexey Salangin on 03.06.2022.
//

import Foundation
import SwiftUI
import UIKit

enum Tab: Int, CaseIterable {
    case search
    case favorites
}

struct PresentationOptions {
    static let `default` = PresentationOptions(hidesBottomBarWhenPushed: false)
    let hidesBottomBarWhenPushed: Bool
}

final class Router: NSObject, ObservableObject {
    @Published private var currentScreen: Screen = .choose
    @Published private var currentTab: Tab = .search

    private var tabNavigationControllers: [Tab: UINavigationController] = [:]

    var needsShowBackButton: Bool {
        let currentRootController = self.viewController(for: currentTab)
        let navigationController = currentRootController
        return navigationController.viewControllers.count > 1
    }

    func tabBarViewControllers() -> [UIViewController] {
        Tab.allCases.map(viewController(for:))
    }

    func push(screen: Screen) {
        let nextView = makeView(for: screen)
        let options = options(for: screen)

        let currentRootController = self.viewController(for: currentTab)
        let hostingController = SneakersHostingController(rootView: nextView)
        hostingController.hideTabBar = options.hidesBottomBarWhenPushed

        currentRootController.pushViewController(hostingController, animated: true)
    }

    private func makeView(for screen: Screen) -> AnyView {
        let view = screen
            .makeView()
            .environmentObject(self)
        return AnyView(view)
    }

    private func options(for screen: Screen) -> PresentationOptions {
        switch screen {
        case .choose:
            return .default
        case .camera:
            return .init(hidesBottomBarWhenPushed: true)
        case .colorPicker:
            return .default
        case .sneakers:
            return .default
        case .favorites:
            return .default
        }
    }

    private func viewController(for tab: Tab) -> UINavigationController {
        let viewController = tabNavigationControllers[tab] ?? makeNavigationController(for: tab)
        return viewController
    }

    private func makeNavigationController(for tab: Tab) -> UINavigationController {
        switch tab {
        case .search:
            // FOR TEST
//            let image = UIImage(named: "man") ?? UIImage()
//            let colors = ColorFinder().colors(from: image)
//            let colorPickerInput = ColorPickerInput(
//                image: image,
//                colors: colors
//            )
//            let view = makeView(for: .colorPicker(colorPickerInput))

            // FOR TEST


            let view = makeView(for: .choose)

            let searchViewController = SneakersHostingController(rootView: view)
            let searchNavigationController = NavigationController(rootViewController: searchViewController)
            searchNavigationController.tabBarItem = UITabBarItem(
                title: nil,
                image: UIImage(named: "TabBar/search"),
                selectedImage: UIImage(named: "TabBar/search")
            )
            searchNavigationController.tabBarItem.imageInsets = .init(top: 2, left: 0, bottom: 0, right: 0)
            tabNavigationControllers[tab] = searchNavigationController
            return searchNavigationController
        case .favorites:
            let favoritesViewController = SneakersHostingController(
                rootView: makeView(for: .favorites)
            )
            let favoritesNavigationController = NavigationController(rootViewController: favoritesViewController)
            favoritesNavigationController.tabBarItem = UITabBarItem(
                title: nil,
                image: UIImage(named: "TabBar/favorites"),
                selectedImage: UIImage(named: "TabBar/favorites")
            )
            favoritesNavigationController.tabBarItem.imageInsets = .init(top: 2, left: 0, bottom: 0, right: 0)
            tabNavigationControllers[tab] = favoritesNavigationController
            return favoritesNavigationController
        }
    }
}

extension Router: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }
        guard let tab = Tab(rawValue: index) else { return }
        self.currentTab = tab
    }
}
