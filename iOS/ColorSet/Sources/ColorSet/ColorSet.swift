//
//  ColorSet.swift
//
//
//  Created by Alexey Salangin on 12.06.2022.
//

import UIKit
import CoreUtils

public struct ColorSet {
    public let uniqueColors: [UIColor]

    public init(colors: [UIColor]) {
        let containers = colors.lazy.map(\.intValue).map(ColorContainer.init)
        let set = Set(containers)
        let unorderedColors = set.map(\.color)
        let unique = colors.filter { unorderedColors.contains($0.intValue) }
        self.uniqueColors = unique
    }
}
