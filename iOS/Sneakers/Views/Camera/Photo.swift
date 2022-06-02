//
//  Photo.swift
//  Sneakers
//
//  Created by Aleksei Salangin on 02.06.2022.
//

import UIKit

public struct Photo: Identifiable, Equatable {
    public var id: String
    public var originalData: Data

    public init(id: String = UUID().uuidString, originalData: Data) {
        self.id = id
        self.originalData = originalData
    }
}

extension Photo {
    public var compressedData: Data? {
        ImageResizer(targetWidth: 800).resize(data: originalData)?.jpegData(compressionQuality: 0.5)
    }

    public var image: UIImage? {
        guard let data = compressedData else { return nil }
        return UIImage(data: data)
    }
}
