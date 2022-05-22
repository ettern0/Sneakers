//
//  Button360View.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//

import SwiftUI

struct Button360: View {
    let sneaker: Sneaker
    @Binding var show360: Bool

    var body: some View {
        Button {
            show360 = sneaker.has360
        } label: {
            Image(systemName: "arkit")
                .resizable()
                .foregroundColor(.black)
                .opacity(sneaker.has360 ? 0.5 : 0)
        }
    }
}
