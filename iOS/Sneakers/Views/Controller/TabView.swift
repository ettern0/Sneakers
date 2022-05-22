//
//  TabViews.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 22.05.2022.
//

import SwiftUI

struct TabView: View {
    @Binding var active: ViewType

    var body: some View {
        HStack {
            TabButton(imageName: "house", systemImage: true, menuName: "Home", view: .main, active: $active)
            Spacer(minLength: 20)
            TabButton(imageName: "camera", systemImage: true, menuName: "Camera", view: .camera, active: $active)
            Spacer(minLength: 20)
            TabButton(imageName: "camera", systemImage: true, menuName: "Sneakers", view: .sneakers, active: $active)
            Spacer(minLength: 20)
            TabButton(imageName: "camera", systemImage: true, menuName: "Gallery", view: .gallery, active: $active)
        }
        .padding(.vertical, -10)
        .padding(.horizontal, 25)
        .background(Color.white)
        .animation(.spring(), value: active)
    }
}


struct TabButton: View {
    let imageName: String
    let systemImage: Bool
    let menuName: String
    let view: ViewType
    @Binding var active: ViewType

    var image: Image {
        if systemImage {
            return Image(systemName: imageName)
        }
        return Image(imageName)
    }

    var body: some View {

        Button {
            active = view
        } label: {
            VStack {
                if view != active {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.black.opacity(0.2))
                        .padding(.horizontal)
                } else {
                    image
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(y: -20)
                        .padding(.bottom, -20)
                    Text(menuName).fontWeight(.light)
                        .font(.system(size: 15))
                        .foregroundColor(Color.black.opacity(0.7))
                }
            }
        }
    }
}
