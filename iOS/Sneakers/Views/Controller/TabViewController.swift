//
//  TabViewCOntroller.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 24.05.2022.
//

import UIKit
import SwiftUI
import Combine

final class TabBarController: UITabBarController {
    private let router = Router()
    private var cancelBag: Set<AnyCancellable> = []

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

        let searchViewController = UIHostingController<AnyView>(rootView: AnyView(Color.white))
        let rootView = router.makeView(for: router.currentScreen)
            .environmentObject(router)
        searchViewController.rootView = AnyView(rootView)

        router.$currentScreen.sink { [weak self] screen in
            guard let self = self else { return }
            let nextView = self.router.makeView(for: screen)
            let hostingController = UIHostingController(rootView: nextView)
            hostingController.hidesBottomBarWhenPushed = true
            searchViewController.navigationController?.pushViewController(hostingController, animated: true)
        }.store(in: &cancelBag)

        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        searchNavigationController.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )

        let favoritesViewController = UIHostingController<AnyView>(
            rootView: AnyView(FavoritesView())
        )
        favoritesViewController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart")
        )

        viewControllers = [
            searchNavigationController,
            favoritesViewController,
        ]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
