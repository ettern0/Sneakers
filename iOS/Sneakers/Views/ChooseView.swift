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
                VStack(alignment: .leading) {
                    Text("Scan")
                        .font(.system(size: 27))
                        .bold()
                        .foregroundColor(.black)
                    Text("Your color and match it")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.black).opacity(0.2))
                }
                .padding(.bottom, 36)

                Button {
                    router.push(screen: .camera)
                } label: {
                    ChooseButtonContent(header: "Looking for",
                                        endPoint: "Sneakers",
                                        description: "outfit",
                                        imageName: "sneakerChoose")
                }
                .padding(.bottom, 44)

                Button {
                    router.push(screen: .camera)
                } label: {
                    ChooseButtonContent(header: "Looking for",
                                        endPoint: "Outfit",
                                        description: "sneakers",
                                        imageName: "outfitChoose")
                }
                .padding(.bottom, 80)
                Spacer()
            }
            .padding(.horizontal, 16)
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
                    .shadow(radius: 15)
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                    VStack(alignment: .trailing) {
                        Spacer()
                        Text(header)
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                        Text(endPoint)
                            .font(.system(size: 25))
                            .bold()
                            .foregroundColor(.black)
                        Text("Shot your \(description) and")
                            .font(.system(size: 13))
                            .foregroundColor(Color(.black).opacity(0.2))
                        Text("explore the results to match")
                            .font(.system(size: 13))
                            .foregroundColor(Color(.black).opacity(0.2))
                    }
                    .padding(.bottom, 20)
                    .padding(.trailing, 12)
                }
            }
        }
    }
}
