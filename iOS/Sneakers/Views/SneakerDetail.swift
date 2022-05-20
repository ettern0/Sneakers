//
//  SneakerDetail.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI
import NukeUI

struct SneakerDetailView: View {
    var sneaker: Sneaker
    var animation: Namespace.ID
    @EnvironmentObject var viewModel: SneakersViewModel
    @State var show360: Bool = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            GeometryReader { proxy in
                LazyImage(source: sneaker.thumbnail, resizingMode: .aspectFit)
                    .matchedGeometryEffect(id: sneaker.id, in: animation)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: getRect().width,
                           height: proxy.frame(in: .global).minY > 0 ?
                           proxy.frame(in: .global).minY + getRect().width :
                            getRect().width)
                    .offset(y: -proxy.frame(in: .global).minY)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewModel.showDetail = false
                        }
                    }
            }
            .frame(width: getRect().width, height: getRect().width)
            SneakerDescriptionView(sneaker: sneaker, show360: $show360)
        })
        .sheet(isPresented: $show360) {
            View360()
        }
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.all)
    }

    private struct SneakerDescriptionView: View {
        let sneaker: Sneaker
        @EnvironmentObject var viewModel: SneakersViewModel
        @Binding var show360: Bool

        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Button {
                        withAnimation(.easeInOut) {
                            viewModel.showDetail = false
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .trailing)
                            .foregroundColor(.black)
                            .opacity(0.5)
                    }
                    .padding(.horizontal, 20)
                    Button {
                        show360 = true
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .trailing)
                            .foregroundColor(.black)
                            .opacity(0.5)
                    }
                }
                Text(sneaker.shoeName)
                    .font(Font.title).bold()
                Text(sneaker.description)
                Text(sneaker.description)
                Text(sneaker.description)
                Text(sneaker.description)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color(.init(white: 0.98, alpha: 1))
                    .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
                    .ignoresSafeArea())
        }
    }
}
