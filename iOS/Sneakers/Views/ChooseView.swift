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
            Text("Scan")
                .font(Font.ralewayBold(size: 32))
        }
        .padding(.bottom, 52)
    }

    private struct ChooseButtonContent: View {
        let header: String
        let endPoint: String
        let description: String
        let imageName: String
        let isCommingSoon: Bool

        init(header: String, endPoint: String, description: String, imageName: String, isCommingSoon: Bool = false) {
            self.header = header
            self.endPoint = endPoint
            self.description = description
            self.imageName = imageName
            self.isCommingSoon = isCommingSoon
        }

        var body: some View {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .foregroundColor(.white)
                    .frame(maxHeight: .infinity)
                    .shadow(color: .black.opacity(0.1), radius: 15)
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text(header)
                            .font(Font.ralewayMedium(size: 25))
                            .foregroundColor(.black)
                        Text(endPoint)
                            .font(Font.ralewayBold(size: 25))
                            .bold()
                            .foregroundColor(.black)
                        Text("Shot your \(description) and\nexplore the results to match")
                            .font(Font.ralewaySemiBold(size: 13))
                            .foregroundColor(Color(.black).opacity(0.2))
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.bottom, 20)
                    .padding(.trailing, 12)
                }

                if isCommingSoon {
                    HStack {
                        Spacer()

                        Text("Coming soon")
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke()
                                    .foregroundColor(.black)
                            )
                            .foregroundColor(.black)
                            .font(.footnote)
                            .padding()
                    }
                }
            }
            .opacity(isCommingSoon ? 0.5 : 1)
        }
    }
}
