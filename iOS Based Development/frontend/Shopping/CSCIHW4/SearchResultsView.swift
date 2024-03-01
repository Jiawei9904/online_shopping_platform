//
//  SearchResultsView.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/15/23.
//

import SwiftUI
import Alamofire
// 定义搜索结果列表视图


struct SearchResultsView: View {
    @Binding var searchResults: [SearchResultItem]
    @ObservedObject var viewModel: SearchViewModel
    @StateObject var favoriteManager = FavoriteManager()
    @State private var selectedItemId: String? = nil
    @State private var showingToast = false
    @State private var toastMessage = ""
    var body: some View {

        Text("Results")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

        if viewModel.isLoading {
            ProgressView("Please wait...")
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                 
        } else if viewModel.noResults {
            Text("No results found.")
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .foregroundColor(.secondary)
        } else {
            ForEach(searchResults, id: \.itemId) { item in
                NavigationLink(destination: ProductDetailView(item: item, favoriteManager: favoriteManager)) {
                    SearchResultRow(item: item, favoriteManager: favoriteManager).id(item.itemId) // 可点击范围过大
                }.buttonStyle(PlainButtonStyle())
            }.onAppear {
                favoriteManager.loadFavorites() // 加载收藏列表
            }
        }
    }

}





// 假设您有一个 SearchResultRow 视图用于渲染每一行的搜索结果
struct SearchResultRow: View {
    let item: SearchResultItem
    @ObservedObject var favoriteManager: FavoriteManager
    @State var isFavorite: Bool = false
    init(item: SearchResultItem, favoriteManager: FavoriteManager) {
        self.item = item
        self.favoriteManager = favoriteManager
            
        _isFavorite = State(initialValue: favoriteManager.isFavorite(itemId: item.itemId))
    }
    var body: some View {
        HStack {
            // 展示产品图片，使用 AsyncImage 或者自定义的图片加载视图
            AsyncImage(url: item.galleryURL) { phase in
                switch phase {
                case .empty:
                    ProgressView() // 加载中显示一个进度指示器
                case .success(let image):
                    image.resizable() // 成功加载后显示图片
                         .scaledToFit() // 保持图片的纵横比
                         .frame(width: 50, height: 50) // 设置图片的尺寸
                case .failure:
                    Image(systemName: "photo") // 加载失败时显示一个占位符
                         .foregroundColor(.gray)
                @unknown default:
                    EmptyView() // 其他未知状态不显示内容
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(10)

            VStack(alignment: .leading) {
                // 显示产品标题
                Text(item.title)
                    .foregroundColor(.primary)
                    .lineLimit(1) // 限制标题显示一行

                // 显示产品价格
                Text("$\(item.sellingStatus.currentPrice.value)")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                Text("\(Double(item.shippingInfo.shippingServiceCost.value) == 0.0 ? "FREE SHIPPING" : "$\(item.shippingInfo.shippingServiceCost.value)")")
                    .foregroundColor(.gray)

                // 显示邮政编码和条件
                HStack {
                    Text(item.postalCode)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(item.condition.conditionDisplayName)
                        .foregroundColor(.gray)
                }
            }
            Spacer()


            Button(action: {
                if favoriteManager.isFavorite(itemId: item.itemId) {
                    favoriteManager.removeFromFavorites(itemId: item.itemId)
                    
                    
                } else {
                    favoriteManager.addToFavorites(item: item)
                    
                    
                }
            }) {
                Image(systemName: favoriteManager.isFavorite(itemId: item.itemId) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
            .onAppear {
                // 当这一行出现时，同步收藏状态
                isFavorite = favoriteManager.isFavorite(itemId: item.itemId)
            }
        }
    }
    
}



