//
//  TabBarViewRepresentation.swift
//  Sneakers
//
//  Created by Alexey Salangin on 04.06.2022.
//

import SwiftUI
import UIKit

struct TabBarViewRepresentation {
    @EnvironmentObject private var router: Router
}

extension TabBarViewRepresentation: UIViewControllerRepresentable {
    typealias UIViewControllerType = TabBarController

    func makeUIViewController(context: Context) -> TabBarController {
        UIViewControllerType(router: router)
    }

    func updateUIViewController(_ uiViewController: TabBarController, context: Context) {
    }
}
