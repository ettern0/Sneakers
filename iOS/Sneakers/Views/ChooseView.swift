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
            ZStack(alignment: .top) {
                ChooseButtonContent(header: "Looking for",
                                    endPoint: "Outfit",
                                    description: "sneakers",
                                    imageName: "outfitChoose")
                .opacity(0.5)

                Text("Coming soon")
                    .foregroundColor(.black.opacity(0.4))
                    .font(Font.system(size: 32, weight: .black))
                    .padding(.top, 10)
            }
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
            }
        }
    }
}
