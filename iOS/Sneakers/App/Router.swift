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

struct PresentationOptions {
    static let `default` = PresentationOptions(hidesBottomBarWhenPushed: false)

    let hidesBottomBarWhenPushed: Bool
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
                title: "Search",
                image: UIImage(systemName: "magnifyingglass"),
                selectedImage: UIImage(systemName: "magnifyingglass")
            )
            tabNavigationControllers[tab] = searchNavigationController
            return searchNavigationController
        case .favorites:
            let favoritesViewController = SneakersHostingController(
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

final class SneakersHostingController: UIHostingController<AnyView> {
    var hideTabBar: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tabBar = self.tabBarController?.tabBar else { return }
        guard let tabBarSuperview = tabBar.superview else { return }

        self.transitionCoordinator?.animateAlongsideTransition(in: tabBar, animation: { _ in
            tabBar.frame.origin.y = tabBarSuperview.bounds.height - (self.hideTabBar ? 0 : tabBar.bounds.height)
        })
    }
}
