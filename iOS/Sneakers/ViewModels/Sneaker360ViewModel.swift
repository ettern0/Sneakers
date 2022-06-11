//
//  Sneaker360.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 18.05.2022.
//

import SwiftUI
import NukeUI

class Sneaker360ViewModel: ObservableObject {
    let sneakerViewModel: SneakersViewModel?
    @Published var images: [UIImage] = []
    @Published var active: UIImage?

    init(sneakerViewModel: SneakersViewModel) {
        self.sneakerViewModel = sneakerViewModel
        self.images.removeAll()
        self.active = nil

        fetchImages { images in
            var buffer: [UIImage] = []
            images.sorted(by: { $0 < $1 }).forEach { image in
                buffer.append(image.uiImage)
            }
            self.images = buffer
            self.active = buffer.first
        }
    }

    struct ImageURL: Comparable {
        static func < (lhs: Sneaker360ViewModel.ImageURL, rhs: Sneaker360ViewModel.ImageURL) -> Bool {
            lhs.url < rhs.url
        }
        let url: String
        let uiImage: UIImage
    }

    func fetchImages(completion: @escaping ([ImageURL]) -> Void) {

        let group = DispatchGroup()
        var urls: [ImageURL] = []

        if sneakerViewModel?.detail?.images360.count != 0, let images360_str = sneakerViewModel?.detail?.images360[0] {
            let data = Data(images360_str.utf8)
            if let images = try? JSONDecoder().decode([String].self, from: data) {
                group.enter()
                DispatchQueue.global().async {
                    for urlString in images {
                        var image: UIImage?
                        if let url = URL(string: urlString) {
                            if let data = try? Data(contentsOf: url) {
                                image = UIImage(data: data)
                            }
                        }
                        if let image = image {
                            urls.append(ImageURL(url: urlString, uiImage: image))
                        }
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion(urls)
        }

    }
}
