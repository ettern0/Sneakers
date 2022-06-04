//
//  TabBarController.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 24.05.2022.
//

import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    private let router: Router

    init(router: Router) {
        self.router = router

        super.init(nibName: nil, bundle: nil)

        self.setupViewControllers()
        self.delegate = router
        self.setupAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewControllers() {
        viewControllers = router.tabBarViewControllers()
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .white

        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.cornerRadius = 4
        tabBar.layer.cornerCurve = .continuous
        tabBar.layer.masksToBounds = true
    }
}
