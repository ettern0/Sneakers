//
//  TabViewCOntroller.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 24.05.2022.
//

import UIKit
import SwiftUI


final class TabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

        let searchViewController = UIHostingController<AnyView>(
            rootView: AnyView(ChooseView().ignoresSafeArea())
        )
        searchViewController.tabBarItem = UITabBarItem(
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
            searchViewController,
            favoritesViewController,
        ]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
