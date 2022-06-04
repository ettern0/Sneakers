//
//  TabViewCOntroller.swift
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
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewControllers() {
        viewControllers = router.tabBarViewControllers()
    }
}
