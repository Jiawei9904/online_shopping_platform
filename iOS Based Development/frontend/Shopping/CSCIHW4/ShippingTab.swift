//
//  ShippingTab.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/22/23.
//

import SwiftUI

struct ShippingTab: View {
    @Environment(\.openURL) var openURL
    @ObservedObject var viewModel: ItemDetailsViewModel
    var itemId: String
    var item: SearchResultItem

    var body: some View {

            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    ProgressView("Please wait...")
                } else if let itemDetails = viewModel.itemDetails {
                    // seller part
                    Group {
                        Divider()
                        HStack{
                            Image(systemName: "storefront").font(.headline)
                            Text("Seller").font(.headline)
                        }
                        Divider()
                        if itemDetails.seller.userID != "NA" {
                            HStack {
                                Text("Store Name")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                if let url = URL(string: itemDetails.viewItemURLForNaturalSearch) {
                                                Link(destination: url) {
                                                    Text(itemDetails.seller.userID)
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                                        .foregroundColor(.blue)
                                                }
                                            } else {
                                                // no URL or invaild URL
                                                Text("Invalid URL")
                                            }
                                                        
                            }
                        }
                        if itemDetails.seller.feedbackScore != -1 {
                            HStack {
                                Text("Feedback Score")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text("\(itemDetails.seller.feedbackScore)")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                        }
                        if itemDetails.seller.positiveFeedbackPercent != -1 { // 假设-1表示不存在
                            HStack {
                                Text("Popularity")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text(String(format: "%.2f", itemDetails.seller.positiveFeedbackPercent))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    Divider()

                    // shipping part
                    Group {
                        HStack{
                            Image(systemName: "sailboat").font(.headline)
                            Text("Shipping Info").font(.headline)
                        }
                        
                        Divider()
                        if item.shippingInfo.shippingServiceCost.value != "NA" {
                            HStack {
                                Text("Shipping Cost")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                if item.shippingInfo.shippingServiceCost.value == "0" ||
                                       item.shippingInfo.shippingServiceCost.value == "0.0" {
                                    Text("FREE")
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                } else {
                                    Text(item.shippingInfo.shippingServiceCost.value)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        if item.shippingInfo.shipToLocations != "NA" {
                            HStack {
                                Text("Global Shipping")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text(item.shippingInfo.shipToLocations == "Worldwide" ? "Yes" : "No")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                        }
                        if let handlingTimeInt = Int(item.shippingInfo.handlingTime), handlingTimeInt != -1 {
                            HStack {
                                Text("Handling Time")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                if handlingTimeInt == 1 {
                                    Text("1 day")
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                } else {
                                    Text("\(handlingTimeInt) days")
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                    }
                    Divider()

                    // return policy part
                    Group {
                        HStack{
                            Image(systemName: "return.left").font(.headline)
                            Text("Return policy").font(.headline)
                        }
                        
                        Divider()
                        if itemDetails.returnPolicy.returnsAccepted != "NA" {
                            HStack {
                                Text("Policy")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text(itemDetails.returnPolicy.returnsAccepted)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                        }
                        if itemDetails.returnPolicy.refund != "NA" {
                            HStack {
                                Text("Refund Mode")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text(itemDetails.returnPolicy.refund)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                        }
                        if itemDetails.returnPolicy.returnsWithin != "NA" {
                            HStack {
                                Text("Refund Within")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text(itemDetails.returnPolicy.returnsWithin)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                        }
                        if itemDetails.returnPolicy.shippingCostPaidBy != "NA" {
                            HStack {
                                Text("Shipping Cost Paid By")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text(itemDetails.returnPolicy.shippingCostPaidBy)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
                
            }
            .padding()
            .navigationTitle("Shipping")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
    //            if viewModel.itemDetails == nil {
    //                viewModel.fetchItemDetails(itemId: itemId)
    //            }
                viewModel.fetchItemDetails(itemId: itemId)
            }
    }
}
