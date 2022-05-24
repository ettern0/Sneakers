//
//  SneakersApp.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI

@main
struct SneakersApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarViewRepresentation()
                .ignoresSafeArea()
                .preferredColorScheme(.light)
        }
    }
}

struct TabBarViewRepresentation: UIViewControllerRepresentable {
    typealias UIViewControllerType = TabBarController

    func makeUIViewController(context: Context) -> TabBarController {
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }

        return TabBarController()
    }

    func updateUIViewController(_ uiViewController: TabBarController, context: Context) {
    }
}
