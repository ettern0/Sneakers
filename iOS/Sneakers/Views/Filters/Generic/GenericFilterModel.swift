//
//  GenericFilterModel.swift
//  Sneakers
//
//  Created by Roman Mazeev on 07/06/22.
//

import Foundation

struct GenericFilterModel<Value: Hashable>: Hashable {
    let value: Value
    var isSelected = false
}
