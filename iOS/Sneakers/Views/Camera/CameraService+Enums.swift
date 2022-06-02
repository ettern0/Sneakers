//
//  CameraService+Enums.swift
//  Sneakers
//
//  Created by Alexey Salangin on 30.05.2022.
//

import Foundation

// MARK: CameraService Enums
extension CameraService {
    enum LivePhotoMode {
        case on
        case off
    }

    enum DepthDataDeliveryMode {
        case on
        case off
    }

    enum PortraitEffectsMatteDeliveryMode {
        case on
        case off
    }

    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }

    enum CaptureMode: Int {
        case photo = 0
        case movie = 1
    }
}
