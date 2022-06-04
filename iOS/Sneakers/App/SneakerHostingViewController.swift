//
//  SneakerHostingViewController.swift
//  Sneakers
//
//  Created by Alexey Salangin on 04.06.2022.
//

import SwiftUI
import UIKit

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
