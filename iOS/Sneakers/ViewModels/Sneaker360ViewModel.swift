//
//  Sneaker360.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 18.05.2022.
//

import SwiftUI
import NukeUI

class Sneaker360ViewModel: ObservableObject {

    @Published var images: [UIImage] = []
    @Published var active: UIImage?

    init() {
        self.images.removeAll()
        self.active = nil

        fetchImages(forURLs: urls) { images in
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

    func fetchImages(forURLs urls: [String], completion: @escaping ([ImageURL]) -> Void) {
        let group = DispatchGroup()
        var images: [ImageURL] = []

        for urlString in urls {
            group.enter()
            DispatchQueue.global().async {
                var image: UIImage?
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        image = UIImage(data: data)
                    }
                }
                if let image = image {
                    images.append(ImageURL(url: urlString, uiImage: image))
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(images)
        }
    }

    var urls: [String] = ["https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img01.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img02.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img03.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img04.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img05.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img06.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img07.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img08.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img09.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img10.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img11.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img12.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img13.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img14.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img15.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img16.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img17.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img18.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img19.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img20.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img21.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img22.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img23.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img24.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img25.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img26.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img27.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img28.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img29.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img30.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img31.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img32.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img33.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img34.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img35.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423",
                  "https://images.stockx.com/360/Air-Jordan-11-Retro-Cool-Grey-2021/Images/Air-Jordan-11-Retro-Cool-Grey-2021/Lv2/img36.jpg?auto=format,compress&w=559&q=90&dpr=2&updated_at=1631898423"]

}
