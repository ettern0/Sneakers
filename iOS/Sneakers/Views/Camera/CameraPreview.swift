//
//  CameraPreview.swift
//  Sneakers
//
//  Created by Alexey Salangin on 30.05.2022.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer // swiftlint:disable:this force_cast
        }
    }

    let session: AVCaptureSession

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        view.videoPreviewLayer.videoGravity = .resizeAspectFill

        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {

    }
}
