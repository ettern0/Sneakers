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

        let searchViewController = UIHostingController<AnyView>(rootView: AnyView(Color.white))

        // TODO: Refactor any move this logic to ForkModule.
        let showSneakers = {
            let palettePicker = UIHostingController(rootView: PalettePickerView())
            palettePicker.hidesBottomBarWhenPushed = true
            searchViewController.navigationController?.pushViewController(palettePicker, animated: true)
        }

        var chooseView = ChooseView()
        chooseView.onTapSneakers = showSneakers

        searchViewController.rootView = AnyView(chooseView)

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
