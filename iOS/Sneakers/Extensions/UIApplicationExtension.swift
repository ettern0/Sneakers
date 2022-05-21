//
//  UIApplicationExtension.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 21.05.2022.
//

import SwiftUI

extension UIApplication {
    func safeArea() -> UIEdgeInsets? {
        UIApplication.shared.windows.first?.safeAreaInsets
    }
}

