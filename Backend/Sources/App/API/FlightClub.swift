//
//  FlightClub.swift
//  
//
//  Created by Evgeny Serdyukov on 03.05.2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getDataFromFlightClub(styleID: String) async throws -> ResponseFromSecondaryAPI {
    let url = URL(string: "https://2fwotdvm2o-dsn.algolia.net/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%20(lite)%203.32.0%3Breact-instantsearch%205.4.0%3BJS%20Helper%202.26.1&x-algolia-application-id=2FWOTDVM2O&x-algolia-api-key=ac96de6fef0e02bb95d433d8d5c7038a")
    guard let requestUrl = url else { fatalError() }
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    let body: [String: Any] = ["requests":
                                [["indexName":"product_variants_v2_flight_club",
                                 "params":"query=\(styleID)&hitsPerPage=1&maxValuesPerFacet=1&filters=&facets=%5B%22lowest_price_cents_usd%22%5D"]]]

    let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    request.httpBody = jsonData;

    let (data, _) = try await URLSession.shared.data(for: request)

    do {

        var lowestResellPrice = ""
        var resellLinks = ""

        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        let results = json?["results"] as? [[String: Any]] ?? []
        results.forEach { el in
            let hits = el["hits"] as? [[String: Any]] ?? []
            hits.forEach { el in
                lowestResellPrice = String((el["lowest_price_cents_usd"] as? Double ?? 0.0) / 100)
                resellLinks = "https://www.flightclub.com/\(el["slug"] as? String ?? "")"
                print("\(styleID)")
            }
        }
        return ResponseFromSecondaryAPI(resellLink: resellLinks,
                                        lowestResellPrice: lowestResellPrice)
    }
}

func getPricesFromFlightClub(resellLink: String, styleID: String) async throws -> [SneakerDTO.ResellPrice] {
    // var result: [SneakerDTO.ResellPrice] = []

    var url = URL(string: "https://www.flightclub.com/token")
    guard let requestUrl = url else { fatalError() }

    var request = URLRequest(url: requestUrl)
    let (data, _) = try await URLSession.shared.data(for: request)
    let token = String(data: data, encoding: String.Encoding.utf8) ?? ""

    url = URL(string: "https://www.flightclub.com/graphql")
    guard let requestUrl = url else { fatalError() }

    request = URLRequest(url: requestUrl)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(token, forHTTPHeaderField: "x-csrf-token")

    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        // let results = json?["results"] as? [[String: Any]] ?? []
        return [SneakerDTO.ResellPrice(size: "", price: 0.0)]
    }
    catch {
        return [SneakerDTO.ResellPrice(size: "", price: 0.0)]
    }
}
