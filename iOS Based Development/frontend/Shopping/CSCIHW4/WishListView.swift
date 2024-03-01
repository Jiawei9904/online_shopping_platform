//
//  WishListView.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/26/23.
//


import SwiftUI

//struct WishListView: View {
//    @ObservedObject var viewModel: WishListViewModel
//
//    var body: some View {
//        // 直接使用 List 来显示愿望清单内容
//        if viewModel.isLoading{
//            ProgressView("Loading...")
//                .navigationTitle("Favorites")
//        }else{
//            if viewModel.wishlistItems.isEmpty {
//                Text("No items in wishlist")
//                    .navigationTitle("Favorites")
//                    .onAppear {
//                        viewModel.loadWishlistItems()
//                    }
//            }else{
//                List {
//                    HStack {
//                        Text("Wishlist total(\(viewModel.wishlistItems.count)) items:")
//                            .font(.subheadline)
//                            .foregroundColor(.black)
//                            Spacer()
//                        Text("$\(viewModel.totalCost, specifier: "%.2f")")
//                            .font(.subheadline)
//                            .foregroundColor(.black)
//                    }
//                    .padding(.vertical)
//                        
//                // 显示愿望清单中的每个项目
//                    ForEach(viewModel.wishlistItems) { item in
//                        WishListItemRow(item: item)
//                            .swipeActions {
//                            Button(role: .destructive) {
//                                viewModel.removeWishlistItem(id: item.id)
//                            } label: {
//            //                  Label("Delete", systemImage: "trash")
//                                Text("Delete")
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Favorites")
//                .onAppear {
//                    viewModel.loadWishlistItems()
//                }
//            }
//        }
//        
//    }
//}
//
//

struct WishListView: View {
    @ObservedObject var viewModel: WishListViewModel

    var body: some View {
            ZStack {
                // 加载中的指示器
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    // 检查是否有错误消息
                    if viewModel.wishlistItems.isEmpty {
                        // 如果愿望清单为空
                        Text("No items in wishlist")
                    } else {
                        // 渲染愿望清单的项目
                        wishlistItemsList
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                // 视图出现时加载愿望清单项
               
                    viewModel.loadWishlistItems()
                
            }

    }

    private var wishlistItemsList: some View {
        List {
            HStack {
                Text("Wishlist total (\(viewModel.wishlistItems.count)) items:")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
                Text("$\(viewModel.totalCost, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(.vertical)

            ForEach(viewModel.wishlistItems, id: \.id) { item in
                WishListItemRow(item: item)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.removeWishlistItem(id: item.id)
                        } label: {
                            Text("Delete")
                        }
                    }
            }
        }
    }
}

struct WishListItemRow: View {
    let item: WishListItem

    var body: some View {
        HStack {
            // 如果有图片链接，这里可以显示图片
            if let urlString = item.galleryURL.first, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(item.firstTitle)
                    .font(.headline)
                    .lineLimit(1)
                Text("$\(item.sellingStatus.first?.convertedCurrentPrice.first?.value ?? "0")")
                    .font(.headline)
                    .foregroundColor(.blue)
                if let shippingCost = item.shippingInfo.first?.shippingServiceCost.first?.value, shippingCost == "0.0" {
                    Text("FREE SHIPPING")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("$\(item.shippingInfo.first?.shippingServiceCost.first?.value ?? "0")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text(item.firstPostalCode)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(item.condition.first?.conditionDisplayName ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            
        }
    }
}






//struct WishListView: View {
//    @ObservedObject var viewModel: WishListViewModel
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .navigationTitle("Favorite")
//    }
//}


