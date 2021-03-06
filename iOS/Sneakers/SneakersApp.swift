//
//  SneakersApp.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI

@main
struct SneakersApp: App {
    private let router = Router()

    var body: some Scene {
        WindowGroup {
            TabBarViewRepresentation()
                .ignoresSafeArea()
                .preferredColorScheme(.light)
                .environmentObject(router)
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = .black
                    UIPageControl.appearance().pageIndicatorTintColor = .init(white: 0.8, alpha: 1)
                }
        }
    }
}
