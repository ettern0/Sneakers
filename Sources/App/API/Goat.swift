//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 03.05.2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getDataFromGoat(styleID: String) async throws -> ResponseFromSecondaryAPI {
    let url = URL(string: "https://2fwotdvm2o-dsn.algolia.net/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%20(lite)%203.25.1%3Breact%20(16.9.0)%3Breact-instantsearch%20(6.2.0)%3BJS%20Helper%20(3.1.0)&x-algolia-application-id=2FWOTDVM2O&x-algolia-api-key=ac96de6fef0e02bb95d433d8d5c7038a")
    guard let requestUrl = url else { fatalError() }

    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "accept")

    let body: [String: Any] = ["requests":
                                [["indexName":"product_variants_v2",
                                 "params":"distinct=true&maxValuesPerFacet=1&page=0&query=\(styleID)&facets=%5B%22instant_ship_lowest_price_cents"]]]

    let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    request.httpBody = jsonData;

    let (data, _) = try await URLSession.shared.data(for: request)

    do {
        var lowestResellPrice = ""
        var resellLinks = ""
        var productID = 0

        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        let results = json?["results"] as? [[String: Any]] ?? []
        results.forEach { el in
            let hits = el["hits"] as? [[String: Any]] ?? []
            hits.forEach { el in
                lowestResellPrice = String((el["lowest_price_cents_usd"] as? Double ?? 0.0) / 100)
                resellLinks = "http://www.goat.com/sneakers/\(el["slug"] as? String ?? "")"
                productID = el["product_template_id"] as? Int ?? 0
            }
        }
        return ResponseFromSecondaryAPI(resellLink: resellLinks,
                                        lowestResellPrice: lowestResellPrice,
                                        goatProductId: productID)
    }
}

func getPricesFromGoat(productID: Int) async throws -> [SneakerDTO.ResellPrice] {
    var result: [SneakerDTO.ResellPrice] = []

    let url = URL(string: "http://www.goat.com/web-api/v1/product_variants/buy_bar_data?productTemplateId=\(productID)")
    guard let requestUrl = url else { fatalError() }

    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let (data, _) = try await URLSession.shared.data(for: request)
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]]
        json?.forEach { val in
            let condition = val["shoeCondition"] as? String ?? ""

            var size = ""
            if let sizeOption = val["sizeOption"] as? [String: Any], let value = sizeOption["value"] as? Double {
                size = String(value)
            }

            var price = 0.0
            if let priceCents = val["lowestPriceCents"] as? [String: Any], let value = priceCents["amount"] as? Double {
                price = value / 100
            }
            if condition != "used" {
                result.append(SneakerDTO.ResellPrice(size: size, price: price))
            }
        }
        return result
    }
    catch {
        return result
    }
}
