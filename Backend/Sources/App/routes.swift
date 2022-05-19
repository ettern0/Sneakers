//
//  routes.swift
//
//
//  Created by Evgeny Serdyukov on 28.04.2022.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {

    //MARK: Check API
    app.get { req in
        return "It works!"
    }

    //MARK: Check API
    app.get("CheckSneakersExternalAPI") { req async throws -> String in
        let result = try await getProductData(keyWord: "", page: 0, count: 10)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(result)
        return String(decoding: jsonData, as: UTF8.self)
    }

    app.get("sneakerInfo", ":urlKey") { req async throws -> String in
        guard let urlKey = req.parameters.get("urlKey") else {
            throw Abort(.internalServerError)
        }
        let result = try await getProductInfoFromStockX(urlKey: urlKey)
        return result
    }

    //MARK: Sneakers DB Controller
    try app.register(collection: SneakersController())
}
