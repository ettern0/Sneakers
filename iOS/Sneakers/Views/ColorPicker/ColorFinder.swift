//
//  ColorFinder.swift
//  Sneakers
//
//  Created by Alexey Salangin on 06.06.2022.
//

import Foundation
import UIKit
import ColorSet

import BackgroundRemoval

final class ColorFinder {
    private let backgroundRemoval = BackgroundRemoval()

    func colors(from image: UIImage) -> [UInt32] {
        let processedImage: UIImage
        if let mask = backgroundRemoval.removeBackground(image: image, maskOnly: true).invertedImage(),
           let maskedImage = image.masked(with: mask) {
            processedImage = maskedImage
        } else {
            assertionFailure("Can not remove background.")
            processedImage = image
        }

        let dominantColors = processedImage.findDominantColors()
        let uniqueColors = ColorSet(colors: dominantColors).uniqueColors.prefix(4).map(\.intValue)
        return Array(uniqueColors)
    }
}

extension UIImage {
    fileprivate func masked(with mask: UIImage) -> UIImage? {
        guard let imageReference = cgImage else { return nil }
        guard let maskReference = mask.cgImage else { return nil }
        guard let dataProvider = maskReference.dataProvider else { return nil }

        guard let imageMask = CGImage(
            maskWidth: maskReference.width,
            height: maskReference.height,
            bitsPerComponent: maskReference.bitsPerComponent,
            bitsPerPixel: maskReference.bitsPerPixel,
            bytesPerRow: maskReference.bytesPerRow,
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: false
        ) else { return nil }

        guard let maskedReference = imageReference.masking(imageMask) else { return nil }

        let maskedImage = UIImage(cgImage: maskedReference)
        return maskedImage
    }
}

extension UIImage {
    fileprivate func invertedImage() -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let img = CIImage(cgImage: cgImage)

        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setDefaults()
        filter.setValue(img, forKey: "inputImage")

        let context = CIContext(options: nil)

        guard let output = filter.outputImage else { return nil }
        guard let resultCGImage = context.createCGImage(output, from: output.extent) else { return nil }

        return UIImage(cgImage: resultCGImage)
    }
}
