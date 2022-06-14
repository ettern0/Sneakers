//
//  File.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 14.06.2022.
//

import SwiftUI

struct ChooseButtonContent: View {
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
            descriptionView
            if isCommingSoon {
                comingSoonView
            }
        }
        .opacity(isCommingSoon ? 0.5 : 1)
    }

    private var descriptionView: some View {
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
                Text("Shot your \(description) and explore the results to match")
                    .font(Font.ralewaySemiBold(size: 13))
                    .foregroundColor(Color(.black).opacity(0.2))
                    .multilineTextAlignment(.trailing)
            }
            .padding(.bottom, 20)
            .padding(.trailing, 12)
        }
    }

    private var comingSoonView: some View {
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
