//
//  WishListItem.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/26/23.
//

import Foundation
struct WishListItem: Codable, Identifiable {
    var id: String {
        itemId.first ?? UUID().uuidString
    }
    var galleryURL: [String]
    var itemId: [String]
    var title: [String]
    var postalCode: [String]
    var shippingInfo: [ShippingInfo]
    var sellingStatus: [SellingStatus]
    var condition: [Condition]
    var createdAt: Date

    // 计算属性
    var firstGalleryURL: String {
        galleryURL.first ?? ""
    }
    var firstItemId: String {
        itemId.first ?? ""
    }
    var firstTitle: String {
        title.first ?? ""
    }
    var firstPostalCode: String {
        postalCode.first ?? ""
    }

    struct ShippingInfo: Codable {
        var shippingServiceCost: [CurrencyValue]
        // 根据需要添加其他字段
    }

    struct SellingStatus: Codable {
        var convertedCurrentPrice: [CurrencyValue]
        // 根据需要添加其他字段
    }

    struct CurrencyValue: Codable {
        var currencyId: String
        var value: String
        enum CodingKeys: String, CodingKey {
            case currencyId = "@currencyId"
            case value = "__value__"
        }
    }

//    struct Condition: Codable {
//        var conditionId: [String]
//        var conditionDisplayName: [String]
//    }
    struct Condition: Codable {
        var conditionId: [String]
        var conditionDisplayName: String {
            // 假设我们只关注第一个 conditionId
            guard let firstConditionId = conditionId.first else { return "NA" }
            switch firstConditionId {
            case "1000":
                return "NEW"
            case "2000":
                return "REFURBISHED"
            case "2500":
                return "REFURBISHED"
            case "3000":
                return "USED"
            case "4000":
                return "USED"
            case "5000":
                return "USED"
            case "6000":
                return "USED"
            default:
                return "NA"
            }
        }
    }
}
