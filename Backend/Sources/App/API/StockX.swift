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

func getDataFromStockX(keyWord: String, count: Int, detailDownloadIsApproved: inout Bool) async throws -> [SneakerDTO] {
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

    //let postString = "{\"params\":\"query=\(keyWord)&facets=*&filters=&page=\(page)&hitsPerPage=\(count)\"}"
    let postString = "{\"params\":\"query=\(keyWord)&facets=*&filters=&hitsPerPage=\(count)\"}"
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
            var resellLinkStockX: String = ""

            if let traits = el["searchable_traits"], let dict = traits as? [String:Any] {
                retailPrice = dict["Retail Price"] as? Double ?? 0
            }

            if let traits = el["media"], let dict = traits as? [String:Any] {
                thumbnail = dict["imageUrl"] as? String ?? ""
            }

            if let url = el["url"] {
                resellLinkStockX = "https://stockx.com/'\(url)"
            }            

            var sneaker = SneakerDTO(shoeName: el["name"] as? String ?? "",
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
                                  resellLinkStockX: resellLinkStockX,
                                  lowestResellPriceStockX: el["lowest_ask"] as? String ?? "")

            do {
                if detailDownloadIsApproved {
                    sleep(1)
                    if let data = try await getProductInfoFromStockX(urlKey: sneaker.urlKey) {
                        sneaker.detailsDownloaded = true
                        sneaker.brand = data.brand
                        sneaker.condition = data.condition
                        sneaker.countryOfManufacture = data.countryOfManufacture
                        sneaker.primaryCategory = data.primaryCategory
                        sneaker.secondaryCategory = data.secondaryCategory
                        sneaker.releaseDate = data.releaseDate
                        sneaker.year = data.year
                        sneaker.images360 = data.images360
                        sneaker.has360 = data.has360
                        sneaker.resellPricesStockX = data.resellPricesStockX
                    } else {
                        detailDownloadIsApproved = false
                    }
                }
                sneakers.append(sneaker)
            } catch {
                print("Fetching product details failed with error \(error)")
            }
        }
        return sneakers
    } catch {
        print("Fetching images failed with error \(error)")
        return []
    }
}

func getProductInfoFromStockX(urlKey: String) async throws -> SneakerDTO? {
    let url = URL(string: "https://stockx.com/api/products/\(urlKey)?includes=market")
    guard let requestUrl = url else { fatalError() }
    var request = URLRequest(url: requestUrl)
    request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
    let (data, response) = try await URLSession.shared.data(for: request)

    var resellPrices: [SneakerDTO.ResellPrice] = []

    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        let info = json?["Product"] as? [String: Any]
        let media = info?["media"] as? [String:Any]
        let has360 = media?["has360"] as? Bool ?? false
        let image360 = media?["360"] as? [String]

        let children = info?["children"] as? [String:Any]
        children?.forEach { el in
            if let value = el.value as? [String: Any],
               let size = value["shoeSize"] as? String,
               let market = value["market"] as? [String:Any],
               let price = market["lowestAsk"] as? Double {
                resellPrices.append(SneakerDTO.ResellPrice(size: size, price: price))
            }
        }

        let brand = info?["brand"] as? String ?? ""
        let releaseDate = info?["releaseDate"] as? String ?? ""
        let condition = info?["condition"] as? String ?? ""
        let countryOfManufacture = info?["countryOfManufacture"] as? String ?? ""
        let primaryCategory = info?["primaryCategory"] as? String ?? ""
        let secondaryCategory = info?["secondaryCategory"] as? String ?? ""
        let year = info?["year"] as? String ?? ""

        let result = SneakerDTO(brand: brand,
                                releaseDate: releaseDate,
                                condition: condition,
                                countryOfManufacture: countryOfManufacture,
                                primaryCategory: primaryCategory,
                                secondaryCategory: secondaryCategory,
                                year: year,
                                resellPricesStockX: resellPrices,
                                images360: image360 ?? [""],
                                has360: has360)
        return result
    } catch {
        print("Fetching product details failed with error \(error)")
        return nil
    }
}
