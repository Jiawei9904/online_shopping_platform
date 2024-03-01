//
//  ProductDetailView.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/21/23.
//

import SwiftUI
import Alamofire


struct ProductDetailView: View {
    var item: SearchResultItem
    var favoriteManager: FavoriteManager
    @State private var selectedTab = 0
    @StateObject var viewModel = ItemDetailsViewModel()
    @State private var itemDetails: ItemDetails?
    @Environment(\.openURL) var openURL
    @State private var isFavorite: Bool = false
    @State var isLoading: Bool = false
    init(item: SearchResultItem, favoriteManager: FavoriteManager) {
        self.item = item
        self.favoriteManager = favoriteManager
        _isFavorite = State(initialValue: favoriteManager.isFavorite(itemId: item.itemId))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ProductInfoTab(viewModel: viewModel, itemDetails: $itemDetails, itemId: item.id)
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
                .tag(0)
            ShippingTab(viewModel: viewModel, itemId: item.id, item: item)
                .tabItem {
                    Label("Shipping", systemImage: "shippingbox")
                }
                .tag(1)
            GooglePhotosTab(viewModel: viewModel, itemTitle: item.title)
                .tabItem {
                    Label("Photos", systemImage: "photo.stack")
                }
                .tag(2)
            SimilarProductsTab(viewModel: viewModel, itemId: item.id)
                                .tabItem {
                                    Label("Similar", systemImage: "list.bullet.indent")
                                }
                                .tag(3)
        }
        .navigationBarItems(trailing: HStack {
                    // Facebook分享按钮
                    Button(action: {
                        viewModel.shareOnFacebook { url in
                            if let url = url {
                                openURL(url)
                            } else {
                                // 处理错误
                                print("Unable to fetch the share URL")
                            }
                        }
                    }) {
                        Image("fb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }

                    // favorite button
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                })
        .onAppear {
            viewModel.fetchItemDetails(itemId: item.id)
            viewModel.fetchSimilarItems(itemId: item.id)
            // check if the item has been marked as favorite
            isFavorite = favoriteManager.isFavorite(itemId: item.itemId)
        }
        .padding(0) 

    }
    
    private func toggleFavorite() {
            isFavorite.toggle()
            if isFavorite {
                favoriteManager.addToFavorites(item: item)
            } else {
                favoriteManager.removeFromFavorites(itemId: item.itemId)
            }
        }
}

