//
//  LargeButtonStyle.swift
//  Sneakers
//
//  Created by Alexey Salangin on 04.06.2022.
//

import SwiftUI

public struct LargeButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18).weight(.medium))
            .foregroundColor(.white.opacity(configuration.isPressed ? 0.7 : 1))
            .frame(maxWidth: .infinity)
            .frame(height: 57)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .foregroundColor(.black)
                    .opacity(configuration.isPressed ? 0.7 : 1.0)
            }
    }
}
