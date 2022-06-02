//
//  PalettePickerView.swift
//  Sneakers
//
//  Created by Aleksei Salangin on 30.05.2022.
//

import SwiftUI
import PhotosUI

struct PalettePickerView: View {
    @State private var showSheet: Bool = false
    @State private var inputImage: Image?
    @ObservedObject var mediaItems = PickedMediaItems()

    var body: some View {
        ZStack {
            CameraView()
            Text("Take a photo of your outfit or choose a photo from the gallery")
            Button("Choose from gallery", action: {
                self.showSheet = true
            })
            .fullScreenCover(isPresented: $showSheet, content: {
                PhotoPicker(mediaItems: mediaItems) { _ in
                    // Handle didSelectItems value here...
                    showSheet = false
                }
                .edgesIgnoringSafeArea(.all)
            })
        }
    }
}

struct CameraViewControllerRepresentation: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIHostingController<CameraView>

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIHostingController<CameraView>(rootView: CameraView())
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct AnyViewWithoutTabBar<V: View>: UIViewControllerRepresentable {
    init(_ view: V) {
        self.view = view
    }

    private let view: V

    typealias UIViewControllerType = UIHostingController<AnyView>

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIHostingController<AnyView>(rootView: AnyView(view))
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
