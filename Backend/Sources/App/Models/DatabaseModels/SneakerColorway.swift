//
//  File.swift
//
//
//  Created by Evgeny Serdyukov on 20.05.2022.
//
import Fluent
import Vapor

final class SneakerColorway: Model, Content {
    static let schema = "sneakerColorway"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "sneakerID")
    var sneakerID: UUID?

    @Field(key: "color")
    var color: UInt32

    init() { }

    init(id: UUID?) {
        self.id = (id == nil ? UUID() : id)
    }
}

//extension SneakerColorway {
//    convenience init(id: UUID? = nil, sneakerID: UUID? = nil, color: String) {
//        self.init(id: id)
//        self.sneakerID = sneakerID
//        self.color = color
//    }
//
//    func update(color: String) {
//        self.color = color
//    }
//}
