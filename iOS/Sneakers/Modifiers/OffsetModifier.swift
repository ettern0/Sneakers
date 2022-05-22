//
//  OffsetModifier.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//

import SwiftUI

// Getting Scrollview offset
struct OffsetModifier: ViewModifier {

    @Binding var offset: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay( GeometryReader { proxy -> Color in
                // Getting value for coordinate space called DETAILSCROLL
                let minY = proxy.frame(in: .named("DETAILSCROLL")).minY
                DispatchQueue.main.async {
                    self.offset = minY
                }
                return Color.clear
            }, alignment: .top)
    }
}
