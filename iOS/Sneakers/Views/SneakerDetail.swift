//
//  SneakerDetail.swift
//  SneakersUIEffects
//
//  Created by Evgeny Serdyukov on 16.05.2022.
//

import SwiftUI

struct SneakerDetail: View {
    var sneaker: Sneaker

    @EnvironmentObject var sharedData: SharedDataModel

    var body: some View {
        // Title Bar Product Image
        VStack{

            Button {

            } label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(Color.black.opacity(0.7))

                Spacer()

                Button {

                } label: {
                    Image(systemName: "arrow.right")
                }
            }

        }

        // product details
        ScrollView(.vertical, showsIndicators: false) {

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }


}

