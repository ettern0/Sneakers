//
//  ChooseView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 25.05.2022.
//

import SwiftUI
import DesignSystem

struct ChooseView: View {
    @EnvironmentObject private var router: Router

    var body: some View {
        VStack(alignment: .leading) {
            header
            buttonSneakers
            buttonOutfit
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    var buttonSneakers: some View {
        Button {
            router.push(screen: .camera)
        } label: {
            ChooseButtonContent(header: "Looking for",
                                endPoint: "Sneakers",
                                description: "outfit",
                                imageName: "sneakerChoose")
        }
        .padding(.bottom, 44)
    }

    var buttonOutfit: some View {
        Button {
            router.push(screen: .camera)
        } label: {
            ChooseButtonContent(
                header: "Looking for",
                endPoint: "Outfit",
                description: "sneakers",
                imageName: "outfitChoose",
                isCommingSoon: true
            )
        }
        .padding(.bottom, 80)
        .disabled(true)
    }

    var header: some View {
        VStack(alignment: .leading) {
            Text("Search")
                .font(Font.ralewayBold(size: 32))
        }
        .padding(.bottom, 52)
    }
}
