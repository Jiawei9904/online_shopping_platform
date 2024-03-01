//
//  ItemDetails.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/22/23.
//


import Foundation
import SwiftyJSON

struct ItemDetails: Encodable {
    let originalJSON: JSON
    var currentPrice: Price
    var itemSpecifics: ItemSpecifics
    var pictureURL: [String]
    var seller: Seller
    var returnPolicy: ReturnPolicy
    var viewItemURLForNaturalSearch: String
    var title: String

    struct Price: Encodable {
        var currencyID: String
        var value: Double
    }

    struct NameValueList: Encodable {
        var name: String
        var value: [String]
    }

    struct ItemSpecifics: Encodable {
        var nameValueList: [NameValueList]
    }

    struct Seller: Encodable {
        var feedbackRatingStar: String
        var feedbackScore: Int
        var positiveFeedbackPercent: Double
        var topRatedSeller: Bool
        var userID: String
    }

    struct ReturnPolicy: Encodable {
        var internationalRefund: String
        var internationalReturnsAccepted: String
        var internationalReturnsWithin: String
        var internationalShippingCostPaidBy: String
        var refund: String
        var returnsAccepted: String
        var returnsWithin: String
        var shippingCostPaidBy: String
    }

    init?(json: JSON) {
        print("Item Details JSON: \(json["Item"])")
        self.originalJSON = json
        self.title = json["Title"].string ?? "No Title"
        
        self.currentPrice = Price(
            currencyID: json["CurrentPrice"]["CurrencyID"].string ?? "NA",
            value: json["CurrentPrice"]["Value"].double ?? -1
        )

        self.itemSpecifics = ItemSpecifics(
            nameValueList: json["ItemSpecifics"]["NameValueList"].arrayValue.map { nvJSON in
                NameValueList(
                    name: nvJSON["Name"].string ?? "NA",
                    value: nvJSON["Value"].arrayValue.compactMap { $0.string }
                )
            }
        )

        self.pictureURL = json["PictureURL"].arrayValue.compactMap { $0.string }

        self.seller = Seller(
            feedbackRatingStar: json["Seller"]["FeedbackRatingStar"].string ?? "NA",
            feedbackScore: json["Seller"]["FeedbackScore"].int ?? -1,
            positiveFeedbackPercent: json["Seller"]["PositiveFeedbackPercent"].double ?? -1,
            topRatedSeller: json["Seller"]["TopRatedSeller"].bool ?? false,
            userID: json["Seller"]["UserID"].string ?? "NA"
        )

        self.returnPolicy = ReturnPolicy(
            internationalRefund: json["ReturnPolicy"]["InternationalRefund"].string ?? "NA",
            internationalReturnsAccepted: json["ReturnPolicy"]["InternationalReturnsAccepted"].string ?? "NA",
            internationalReturnsWithin: json["ReturnPolicy"]["InternationalReturnsWithin"].string ?? "NA",
            internationalShippingCostPaidBy: json["ReturnPolicy"]["InternationalShippingCostPaidBy"].string ?? "NA",
            refund: json["ReturnPolicy"]["Refund"].string ?? "NA",
            returnsAccepted: json["ReturnPolicy"]["ReturnsAccepted"].string ?? "NA",
            returnsWithin: json["ReturnPolicy"]["ReturnsWithin"].string ?? "NA",
            shippingCostPaidBy: json["ReturnPolicy"]["ShippingCostPaidBy"].string ?? "NA"
        )

        // 新添加的 viewItemURL 变量处理
        self.viewItemURLForNaturalSearch = json["ViewItemURLForNaturalSearch"].string ?? "No URL"
        print("ViewItemURLForNaturalSearch: \(self.viewItemURLForNaturalSearch)")
    }
}
