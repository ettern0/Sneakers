//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 12.05.2022.
//

import Fluent
import Vapor

final class Sneaker360Presentation: Model, Content {
    static let schema = "sneakers360Presentation"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "sneakerID")
    var sneakerID: UUID?

    @Field(key: "image")
    var image: String

    init() { }

    init(id: UUID?) {
        self.id = (id == nil ? UUID() : id)
    }
}

extension Sneaker360Presentation {
    convenience init(id: UUID? = nil, sneakerID: UUID? = nil, image: String) {
        self.init(id: id)
        self.sneakerID = sneakerID
        self.image = image
    }

    func update(image: String) {
        self.image = image
    }
}
