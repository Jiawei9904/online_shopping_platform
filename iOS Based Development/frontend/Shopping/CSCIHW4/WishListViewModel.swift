//
//  WishListViewModel.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/26/23.
//

import Foundation
import Alamofire

class WishListViewModel: ObservableObject {
    @Published var wishlistItems: [WishListItem] = []
    @Published var totalCost: Double = 0.0
    @Published var isLoading: Bool = false
    // 初始化 JSON 解码器，配置 ISO 8601 日期格式解码
    private let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            return decoder
        }()


    // 加载愿望清单项
    func loadWishlistItems() {
        self.isLoading = true
        AF.request("https://swiftbackend-406401.wl.r.appspot.com/api/wishlist", method: .get)
            .validate()
            .responseDecodable(of: [WishListItem].self, decoder: decoder) { response in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // add 0.5 seconds
                    switch response.result {
                    case .success(let items):
                        // 对项目进行排序（如有必要）
                        self.wishlistItems = items.sorted { $0.createdAt < $1.createdAt }
                        self.calculateTotalCost()
                        self.isLoading = false
                    case .failure(let error):
                        print("Error while fetching wishlist items: \(error)")
                        // 处理错误，例如更新 UI 显示错误信息
                        self.isLoading = false
                    }
                }
            }
    }


    // 删除愿望清单项
    func removeWishlistItem(id: String) {
        // 发送删除请求到服务器
        AF.request("https://swiftbackend-406401.wl.r.appspot.com/api/removeFromCart",
            method: .post,
            parameters: ["itemId": id],
            encoder: JSONParameterEncoder.default)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    self.wishlistItems.removeAll { $0.id == id }
                    self.calculateTotalCost()
                }
            case .failure(let error):
                print("Error while deleting wishlist item: \(error)")
                // 处理错误
            }
        }
    }
    
    func calculateTotalCost() {
        totalCost = wishlistItems.reduce(0) { sum, item in
            sum + (Double(item.sellingStatus.first?.convertedCurrentPrice.first?.value ?? "0") ?? 0)
        }
    }
}

