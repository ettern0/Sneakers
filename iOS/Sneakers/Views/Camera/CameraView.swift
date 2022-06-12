//
//  CameraView.swift
//  Sneakers
//
//  Created by Alexey Salangin on 30.05.2022.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject private var router: Router
    @StateObject var model = CameraModel()

    @State var currentZoomFactor: CGFloat = 1.0

    @State private var showGallerySheet: Bool = false
    @ObservedObject var mediaItems = PickedMediaItems()

    private var captureButton: some View {
        Button {
            model.capturePhoto()
            if let image = UIImage(named: "man") {
                let colors = ColorFinder().colors(from: image)
                let input = ColorPickerInput(image: image, colors: colors)
                router.push(screen: .colorPicker(input))
            }
        } label: {
            EmptyView()
        }.buttonStyle(CaptureButtonStyle())
    }

    private var galleryButton: some View {
        Button {
            showGallerySheet = true
        } label: {
            Image("gallery")
                .tint(.black)
        }.frame(width: 32, height: 32)
    }

    private var errorAlert: Alert {
        Alert(
            title: Text(model.alertError.title),
            message: Text(model.alertError.message),
            dismissButton: .default(
                Text(model.alertError.primaryButtonTitle),
                action: {
                    model.alertError.primaryAction?()
                }
            )
        )
    }

    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                CameraPreview(session: model.session)
                    .edgesIgnoringSafeArea(.all)
                    .gesture(
                        DragGesture().onChanged({ (val) in
                            //  Only accept vertical drag
                            if abs(val.translation.height) > abs(val.translation.width) {
                                //  Get the percentage of vertical screen space covered by drag
                                let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                //  Calculate new zoom factor
                                let calc = currentZoomFactor + percentage
                                //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                //  Store the newly calculated zoom factor
                                currentZoomFactor = zoomFactor
                                //  Sets the zoom factor to the capture device session
                                model.zoom(with: zoomFactor)
                            }
                        })
                    )
                    .onAppear {
                        model.configure()
                    }
                    .alert(isPresented: $model.showAlertError, content: {
                        errorAlert
                    })
                    .overlay(
                        Group {
                            if model.willCapturePhoto {
                                Color.black
                            }
                        }
                    )

                VStack {
                    Spacer()
                    bottomPanel
                }
            }
        }
        .fullScreenCover(isPresented: $showGallerySheet, content: {
            PhotoPicker(mediaItems: mediaItems) { _ in
                showGallerySheet = false
            }
            .edgesIgnoringSafeArea(.all)
        })
    }

    @ViewBuilder
    private var bottomPanel: some View {
        HStack(spacing: 0) {
            Group {
                galleryButton
            }
            .frame(maxWidth: .infinity)

            captureButton
                .padding(17)
                .frame(maxWidth: .infinity)

            Group {
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .background(.white)
    }
}
