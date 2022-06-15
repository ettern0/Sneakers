//
//  UIImage+dominantColor.swift
//  Sneakers
//
//  Created by Alexey Salangin on 12.06.2022.
//

import UIKit
import DominantColor

extension UIImage {
    func findDominantColors() -> [UIColor] {
        (try? self.dominantColorFrequencies(with: .best).map(\.color)) ?? []
    }
}
