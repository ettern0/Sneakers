//
//  StockX.swift
//  
//
//  Created by Evgeny Serdyukov on 28.04.2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getDataFromStockX(keyWord: String, page: Int = 1, count: Int) async throws -> [SneakerDTO] {
    var sneakers: [SneakerDTO] = []
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

        for index in 0..<hits.count {
            let el = hits[index]

            guard el["url"] as? String ?? "" != "",
                  el["style_id"] as? String ?? "" != "" else {
                continue
            }

            var retailPrice: Double = 0
            var thumbnail: String = ""

            if let traits = el["searchable_traits"], let dict = traits as? [String:Any] {
                retailPrice = dict["Retail Price"] as? Double ?? 0
            }

            if let traits = el["media"], let dict = traits as? [String:Any] {
                thumbnail = dict["imageUrl"] as? String ?? ""
            }

            let sneaker = SneakerDTO(shoeName: el["name"] as? String ?? "",
                                  brand: el["brand"] as? String ?? "",
                                  silhoutte: el["make"] as? String ?? "",
                                  styleID: el["style_id"] as? String ?? "",
                                  retailPrice: retailPrice,
                                  releaseDate: el["release_date"] as? String ?? "",
                                  description: el["description"] as? String ?? "",
                                  thumbnail: thumbnail,
                                  urlKey: el["url"] as? String ?? "",
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

func get360FromStockX(urlKey: String) async throws -> [String] {
    let url = URL(string: "https://stockx.com/api/products/\(urlKey)?includes=market")
    guard let requestUrl = url else { fatalError() }
    let request = URLRequest(url: requestUrl)
    let (data, _) = try await URLSession.shared.data(for: request)
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        let product = json?["Product"] as? [String: Any]
        let media = product?["media"] as? [String:Any]
        let has360 = media?["has360"] as? Bool
        guard has360 ?? false else { return [] }
        let image360 = media?["360"] as? [String]
        return image360 ?? []
    }
    catch {
        return []
    }
}

func getPricesFromStockX(urlKey: String) async throws -> [SneakerDTO.ResellPrice] {
    var result: [SneakerDTO.ResellPrice] = []
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
                result.append(SneakerDTO.ResellPrice(size: size, price: price))
            }
        }
        return result
    }
    catch {
        return result
    }
}
