//
//  CaptureButtonStyle.swift
//  Sneakers
//
//  Created by Alexey Salangin on 02.06.2022.
//

import SwiftUI

struct CaptureButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Circle()
            .strokeBorder(.black, lineWidth: 3)
            .foregroundColor(.white)
            .frame(width: 62, height: 62, alignment: .center)
            .overlay(
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48, alignment: .center)
                    .shadow(color: .black.opacity(0.4), radius: configuration.isPressed ? 2 : 4, x: 0, y: 0)
                    .scaleEffect(configuration.isPressed ? 0.97 : 1, anchor: .center)
                    .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
            )
      }
}
