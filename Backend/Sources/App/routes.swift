//
//  routes.swift
//
//
//  Created by Evgeny Serdyukov on 28.04.2022.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {

    // MARK: Check API
    app.get { req in
        return "It works!"
    }

    // MARK: Sneakers DB Controller
    try app.register(collection: SneakersController())
}
