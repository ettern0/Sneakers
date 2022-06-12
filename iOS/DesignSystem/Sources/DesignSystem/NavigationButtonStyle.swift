//
//  NavigationButtonStyle.swift
//  
//
//  Created by Aleksei Salangin on 12.06.2022.
//

import SwiftUI

public struct NavigationButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 43, height: 43)
            .background(content: {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.08), radius: 6)
            })
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
