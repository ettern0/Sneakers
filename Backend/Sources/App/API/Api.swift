//
//  API.swift
//  
//
//  Created by Evgeny Serdyukov on 29.04.2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

//DD1391-100

func getProductData(keyWord: String, count: Int) async throws -> [SneakerDTO] {

    do {
        var detailDownloadIsApproved = true
        var sneakers = try await getDataFromStockX(keyWord: keyWord, count: count, detailDownloadIsApproved: &detailDownloadIsApproved)
        for i in 0..<sneakers.count {

            //MARK: TODO additional, comment false
            if false {
                //MARK: additional data from secondary API
                //let dataFromStadiumGoods = try await getDataFromStadiumgoods(styleID: sneakers[i].styleID)
                let dataFromGoat = try await getDataFromGoat(styleID: sneakers[i].styleID)
                sneakers[i].goatProductId = dataFromGoat.goatProductId
                sneakers[i].resellLinkGoat = dataFromGoat.resellLink
                sneakers[i].lowestResellPriceGoat = dataFromGoat.lowestResellPrice

                let dataFromFlightClub = try await getDataFromFlightClub(styleID: sneakers[i].styleID)
                sneakers[i].resellLinkFlightClub = dataFromFlightClub.resellLink
                sneakers[i].lowestResellPriceFlightClub = dataFromFlightClub.lowestResellPrice

                //MARK: Prices and sizes
                //            let pricesFromStadiumGoods = try await getPricesFromStadiumGoods(urlKey: sneaker.urlKey)
                sneakers[i].resellPricesGoat = try await getPricesFromGoat(productID: sneakers[i].goatProductId)
                // sneakers[i].resellPricesFlightClub = try await getPricesFromFlightClub(resellLink: sneakers[i].resellLinkFlightClub, styleID: sneakers[i].styleID)
            }
            return sneakers
        }
        
    } catch {
        print("Fetching images failed with error \(error)")
    }
    return []
}
