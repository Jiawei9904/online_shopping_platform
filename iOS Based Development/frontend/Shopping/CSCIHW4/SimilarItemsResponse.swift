//
//  SimilarItemsResponse.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/25/23.
//

import Foundation
struct SimilarItemsResponse: Codable {
    let getSimilarItemsResponse: GetSimilarItemsResponse
}

struct GetSimilarItemsResponse: Codable {
    let itemRecommendations: ItemRecommendations
}

struct ItemRecommendations: Codable {
    let item: [SimilarItem]
}

struct SimilarItem: Codable, Identifiable {
    let id = UUID()
    let itemId: String
    let title: String
    let imageURL: String
    let buyItNowPrice: Price
    let shippingCost: Price
    let timeLeft: String
    let viewItemURL: String
    enum CodingKeys: String, CodingKey {
        case itemId, title, imageURL, buyItNowPrice, shippingCost, timeLeft, viewItemURL
    }
    
    var daysLeft: Int {
        // get days number from the string
        let daysString = timeLeft.extractDaysFromTimeLeft() ?? ""
        return Int(daysString) ?? 0
    }
}

extension String {
    func extractDaysFromTimeLeft() -> String? {
        // get the substring from P and D
        let pattern = "P(\\d+)D"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let nsString = self as NSString
        let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        guard let match = results.first else { return nil }
        return nsString.substring(with: match.range(at: 1))
    }
}

struct Price: Codable {
    let __value__: String
    let currencyId: String

    enum CodingKeys: String, CodingKey {
        case __value__ = "__value__"
        case currencyId = "@currencyId"
    }
    
    var valueAsDouble: Double {
        return Double(__value__) ?? 0.0
    }
}

