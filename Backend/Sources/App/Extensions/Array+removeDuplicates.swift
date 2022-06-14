//
//  Array+removeDuplicates.swift
//  
//
//  Created by Aleksei Salangin on 14.06.2022.
//

import Foundation

extension Array {
    @discardableResult
    mutating func removeDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        self = withoutDuplicates(keyPath: path)
        return self
    }

    func withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        var set = Set<E>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
}
