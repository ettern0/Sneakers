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
        case .sneakers:
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
            let view = makeView(for: .choose)
            let searchViewController = SneakersHostingController(rootView: view)
            let searchNavigationController = UINavigationController(rootViewController: searchViewController)
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
                rootView: AnyView(FavoritesView())
            )
            let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
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
