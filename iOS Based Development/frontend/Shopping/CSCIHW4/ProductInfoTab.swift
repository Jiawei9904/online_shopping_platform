//
//  ProductInfoTab.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/22/23.
//

import SwiftUI

struct ProductInfoTab: View {
    @ObservedObject var viewModel: ItemDetailsViewModel
    @Binding var itemDetails: ItemDetails?
    @State private var currentIndex: Int = 0
    var itemId: String // 传入的产品ID

    var body: some View {

            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    ProgressView("Please wait...")
                } else if let itemDetails = viewModel.itemDetails {
                    // photo set
                    TabView(selection: $currentIndex) {
                        ForEach(Array(itemDetails.pictureURL.enumerated()), id: \.element) { index, url in
                            AsyncImage(url: URL(string: url)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .aspectRatio(contentMode: .fit)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 200)
                    .overlay(
                        GeometryReader { geometry in
                            HStack {
                                Spacer()
                                ForEach(0..<itemDetails.pictureURL.count, id: \.self) { index in
                                    Circle()
                                        .fill(currentIndex == index ? Color.black : Color.gray)
                                        .frame(width: 8, height: 8)
                                }
                                Spacer()
                            }
                            .position(x: geometry.size.width / 2, y: geometry.size.height + 10)
                        }
                    )
                    // title
                    Text(itemDetails.title)
                        .font(.headline)
                        .padding()

                    // price
                    Text(String(format: "$%.2f", itemDetails.currentPrice.value))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "magnifyingglass").font(.headline)
                        Text("Description")
                            .font(.headline)
                        Spacer()
                    }.padding()

                    // show item.specific characters
                    Divider()
                    ScrollView{
                        ForEach(itemDetails.itemSpecifics.nameValueList, id: \.name) { specific in
                            HStack {
                                Text(specific.name)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Text(specific.value.joined(separator: ", "))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            }
                            Divider()
                        }
                    }

                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchItemDetails(itemId: itemId)
            }
    }
}


