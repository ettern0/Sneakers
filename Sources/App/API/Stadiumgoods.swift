//
//  File.swift
//  
//
//  Created by Evgeny Serdyukov on 29.04.2022.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getDataFromStadiumgoods(styleID: String) async throws -> ResponseFromSecondaryAPI {
    //MARK: Example - styleID: DD1391-100
    let url = URL(string: "https://graphql.stadiumgoods.com/graphql")
    guard let requestUrl = url else { fatalError() }

    var request = URLRequest(url: requestUrl)
    //request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("json", forHTTPHeaderField: "responseType")
    // prepare json data
    let body: [String: Any] = ["operationId": "sg-front/cached-a41eba558ae6325f072164477a24d3c2",
                               "variables": ["categorySlug":"",
                                             "initialSearchQuery":"'\(styleID)'",
                                             "initialSort":"RELEVANCE",
                                             "includeUnavailableProducts":"null",
                                             "filteringOnCategory":"false",
                                             "filteringOnBrand":"false",
                                             "filteringOnMensSizes":"false",
                                             "filteringOnKidsSizes":"false",
                                             "filteringOnWomensSizes":"false",
                                             "filteringOnApparelSizes":"false",
                                             "filteringOnGender":"false",
                                             "filteringOnColor":"false",
                                             "filteringOnPriceRange":"false"],
                               "locale": "USA_USD"]
    let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    request.httpBody = jsonData;

    // Perform HTTP Request
    let (data, _) = try await URLSession.shared.data(for: request)

    do {
        let jsonString = String(data: data, encoding: String.Encoding.utf8) ?? ""
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
    }
    return ResponseFromSecondaryAPI()
}
