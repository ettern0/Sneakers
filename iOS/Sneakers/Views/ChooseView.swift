//
//  ChooseView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 25.05.2022.
//

import SwiftUI

struct ChooseView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 36) {
                VStack {
                    Text("What do you need?")
                        .font(.system(size: 27))
                        .bold()
                        .foregroundColor(.black)
                    Text("Choose how to build your outfit")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.black).opacity(0.2))
                }
                .padding(.bottom, 48)
                .padding(.horizontal, 16)
                NavigationLinkView(header: "Looking for", endPoint: "Sneakers", destination: AnyView(SneakersListView()))
                NavigationLinkView(header: "Looking for", endPoint: "Outfit", destination: AnyView(EmptyView()))
                Spacer()
            }
        }
    }

    private struct NavigationLinkView: View {
        let header: String
        let endPoint: String
        let destination: AnyView

        var body: some View {
            NavigationLink(destination: destination) {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(.orange)
                        .frame(maxHeight: getRect().width / 2)
                        .padding(.horizontal, 16)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(header)
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                            Text(endPoint)
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.white)
                        }
                        .padding([.top, .horizontal], 32)
                        Spacer()
                    }
                }
            }
        }
    }
}
