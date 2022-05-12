import Fluent
import Vapor

func routes(_ app: Application) throws {

    //MARK: Check API
    app.get { req in
        return "It works!"
    }

    //MARK: Check API
    app.get("sneakers", ":keyWord", ":page", ":count") { req async throws -> String in
        var keyWord = ""
        var count = 1000
        var page = 1
        if let param = req.parameters.get("keyWord") {
            keyWord = param
        }
        if let param = req.parameters.get("page") {
            page = Int(param) ?? page
        }
        if let param = req.parameters.get("count") {
            count = Int(param) ?? count
        }
        keyWord = (keyWord == "_" ? "" : keyWord)
        let result = try await getProductData(keyWord: keyWord, page: page, count: count)

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
