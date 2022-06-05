//
//  View+if.swift
//  Sneakers
//
//  Created by Alexey Salangin on 05.06.2022.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
