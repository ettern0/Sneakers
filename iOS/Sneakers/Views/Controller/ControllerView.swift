//
//  ControllerView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//

import SwiftUI

struct ControllerView: View {
    @State var active: ViewType = .main

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch active {
                case .main:
                    Color.blue.ignoresSafeArea()
                case .camera:
                    Color.yellow.ignoresSafeArea()
                case .sneakers:
                    SneakersListView()
                case .gallery:
                    Color.cyan.ignoresSafeArea()
                }
            }
            .animation(.easeInOut, value: active)
            TabView(active: $active)
        }
    }
}
