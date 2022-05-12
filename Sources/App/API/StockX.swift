//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 28.04.2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getDataFromStockX(keyWord: String, page: Int = 1, count: Int) async throws -> [SneakerAPI] {
    var sneakers: [SneakerAPI] = []
    let url = URL(string: "https://xw7sbct9v6-1.algolianet.com/1/indexes/products/query?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%203.32.1&x-algolia-application-id=XW7SBCT9V6&x-algolia-api-key=6b5e76b49705eb9f51a06d3c82f7acee")
    guard let requestUrl = url else { fatalError() }

    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "accept")
    request.setValue("en-US,en;q=0.9", forHTTPHeaderField: "accept-language")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    request.setValue("sec-fetch-dest", forHTTPHeaderField: "empty")
    request.setValue("sec-fetch-mode", forHTTPHeaderField: "cors")
    request.setValue("sec-fetch-site", forHTTPHeaderField: "cross-site")

    let postString = "{\"params\":\"query=\(keyWord)&facets=*&filters=&page=\(page)&hitsPerPage=\(count)\"}"
    request.httpBody = postString.data(using: String.Encoding.utf8);

    let (data, _) = try await URLSession.shared.data(for: request)

    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        let hits = json?["hits"] as? [[String: Any]] ?? []

        hits.forEach { el in
            var retailPrice: Double = 0
            var thumbnail: String = ""

            if let traits = el["searchable_traits"], let dict = traits as? [String:Any] {
                retailPrice = dict["Retail Price"] as? Double ?? 0
            }

            if let traits = el["media"], let dict = traits as? [String:Any] {
                thumbnail = dict["imageUrl"] as? String ?? ""
            }

            let sneaker = SneakerAPI(shoeName: el["name"] as? String ?? "",
                                  brand: el["brand"] as? String ?? "",
                                  silhoutte: el["make"] as? String ?? "",
                                  styleID: el["style_id"] as? String ?? "",
                                  retailPrice: retailPrice,
                                  releaseDate: el["release_date"] as? String ?? "",
                                  description: el["description"] as? String ?? "",
                                  thumbnail: thumbnail,
                                  urlKey: URL(string: el["url"] as? String ?? "")!,
                                  make: el["make"] as? String ?? "",
                                  colorway: el["colorway"] as? String ?? "",
                                  resellLinkStockX: el["url"] as? String ?? "",
                                  lowestResellPriceStockX: el["lowest_ask"] as? String ?? "")
            sneakers.append(sneaker)
        }
        return sneakers
    }
}

func getProductInfoFromStockX(urlKey: String) async throws -> String {
    let url = URL(string: "https://stockx.com/api/products/\(urlKey)?includes=market")
    guard let requestUrl = url else { fatalError() }
    let request = URLRequest(url: requestUrl)
    let (data, _) = try await URLSession.shared.data(for: request)
    do {
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}

func getPricesFromStockX(urlKey: String) async throws -> [SneakerAPI.ResellPrice] {
    var result: [SneakerAPI.ResellPrice] = []
    let info = try await getProductInfoFromStockX(urlKey: urlKey)

    do {
        let data = Data(info.utf8)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        let product = json?["Product"] as? [String: Any]
        let children = product?["children"] as? [String:Any]
        children?.forEach { el in
            if let value = el.value as? [String: Any],
               let size = value["shoeSize"] as? String,
               let market = value["market"] as? [String:Any],
               let price = market["lowestAsk"] as? Double {
                result.append(SneakerAPI.ResellPrice(size: size, price: price))
            }
        }
        return result
    }
    catch {
        return result
    }
}
