//
//  SearchResultItem.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/16/23.
//

import Foundation
import SwiftyJSON

struct SearchResultItem: Identifiable, Encodable {
    let originalJSON: JSON
    let id: String
    let title: String
    let galleryURL: URL
    let postalCode: String
    let sellingStatus: SellingStatus
    let shippingInfo: ShippingInfo
    let returnsAccepted: String
    let condition: Condition
    var itemId: String { id }

    struct SellingStatus: Encodable {
        let currentPrice: Price
        let convertedCurrentPrice: Price
        let sellingState: String
        let timeLeft: String
    }

    struct ShippingInfo: Encodable {
        let expeditedShipping: String
        let handlingTime: String
        let oneDayShippingAvailable: String
        let shipToLocations: String
        let shippingServiceCost: Price
        let shippingType: String
    }

    struct Price: Encodable {
        let currencyId: String
        let value: String
    }
    
    struct Condition: Encodable {
        let conditionId: String
        var conditionDisplayName: String {
            switch conditionId {
            case "1000":
                return "NEW"
            case "2000", "2500":
                return "REFURBISHED"
            case "3000", "4000", "5000", "6000":
                    return "USED"
            default:
                return "NA"
            }
        }
    }
}

extension SearchResultItem {
    
    init?(json: JSON) {
        self.originalJSON = json
        guard let itemId = json["itemId"][0].string else {
            print("cannot find items")
            return nil
        }
        // 解析必须字段
        self.id = itemId

        // 解析其他字段，为缺失的字段提供默认值 "NA"
        self.title = json["title"][0].string ?? "NA"
        self.galleryURL = URL(string: json["galleryURL"][0].string ?? "") ?? URL(string: "about:blank")!
        self.postalCode = json["postalCode"][0].string ?? "NA"
        self.returnsAccepted = json["returnsAccepted"][0].string?.lowercased() ?? "NA"

        // 解析 SellingStatus，为缺失的字段提供默认值
        let currentPrice = Price(
            currencyId: json["sellingStatus"][0]["currentPrice"][0]["@currencyId"].string ?? "NA",
            value: json["sellingStatus"][0]["currentPrice"][0]["__value__"].string ?? "NA"
        )
        let convertedCurrentPrice = Price(
            currencyId: json["sellingStatus"][0]["convertedCurrentPrice"][0]["@currencyId"].string ?? "NA",
            value: json["sellingStatus"][0]["convertedCurrentPrice"][0]["__value__"].string ?? "NA"
        )
        let sellingState = json["sellingStatus"][0]["sellingState"][0].string ?? "NA"
        let timeLeft = json["sellingStatus"][0]["timeLeft"][0].string ?? "NA"
        self.sellingStatus = SellingStatus(currentPrice: currentPrice, convertedCurrentPrice: convertedCurrentPrice, sellingState: sellingState, timeLeft: timeLeft)

        // 解析 ShippingInfo，为缺失的字段提供默认值
        let expeditedShipping = json["shippingInfo"][0]["expeditedShipping"][0].string?.lowercased() ?? "NA"
        let handlingTime = json["shippingInfo"][0]["handlingTime"][0].string ?? "NA"
        let oneDayShippingAvailable = json["shippingInfo"][0]["oneDayShippingAvailable"][0].string?.lowercased() ?? "NA"
        let shipToLocations = json["shippingInfo"][0]["shipToLocations"][0].string ?? "NA"
        let shippingServiceCost = Price(
            currencyId: json["shippingInfo"][0]["shippingServiceCost"][0]["@currencyId"].string ?? "NA",
            value: json["shippingInfo"][0]["shippingServiceCost"][0]["__value__"].string ?? "NA"
        )
        let shippingType = json["shippingInfo"][0]["shippingType"][0].string ?? "NA"
        self.shippingInfo = ShippingInfo(
            expeditedShipping: expeditedShipping,
            handlingTime: handlingTime,
            oneDayShippingAvailable: oneDayShippingAvailable,
            shipToLocations: shipToLocations,
            shippingServiceCost: shippingServiceCost,
            shippingType: shippingType
        )
        
        // 解析condition字段
        let conditionId = json["condition"][0]["conditionId"][0].string ?? "NA"
        let conditionDisplayName = json["condition"][0]["conditionDisplayName"][0].string ?? "NA"
        self.condition = Condition(conditionId: conditionId)
    }
    
    func jsonData() -> Data? {
            do {
                return try originalJSON.rawData()
            } catch {
                print("Error converting JSON to Data: \(error)")
                return nil
            }
        }
}


