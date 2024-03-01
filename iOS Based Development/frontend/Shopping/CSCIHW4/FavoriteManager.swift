//
//  FavoriteManager.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/20/23.
//

import Foundation
import Alamofire

class FavoriteManager: ObservableObject {
    @Published var favorites: Set<String> = []
    @Published var activeItems: Set<String> = []
    @Published var toastMessage: String = ""
    init() {
        loadFavorites()
    }


    func isFavorite (itemId: String) -> Bool {
        return favorites.contains(itemId)
    }

    // 修改 addToFavorites 方法，以发送 jsonData
    func addToFavorites(item: SearchResultItem) {
        print("current item wanna insert into database...", item)
        guard let url = URL(string: "https://swiftbackend-406401.wl.r.appspot.com/api/addToCart"),
              let jsonData = item.jsonData() else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        AF.request(request).response { response in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    self.favorites.insert(item.itemId)
                    self.toastMessage = "Added to favorites"
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func removeFromFavorites(itemId: String) {
        let parameters = ["itemId": itemId]
        AF.request("https://swiftbackend-406401.wl.r.appspot.com/api/removeFromCart", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .response { response in
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        self.favorites.remove(itemId)
                        self.toastMessage = "Removed from favorites"
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }


    func loadFavorites() {
        AF.request("https://swiftbackend-406401.wl.r.appspot.com/api/getItemIds", method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    print("Success with JSON: \(json)")
                    do {
                        if let data = response.data {
                            // 修改解码类型为嵌套数组 [[String]]
                            let itemIds = try JSONDecoder().decode([[String]].self, from: data)
                            DispatchQueue.main.async {
                                // 因为你期望的是 String 数组，所以取嵌套数组的第一个元素
                                self.favorites = Set(itemIds.flatMap { $0 })
                            }
                        }
                    } catch {
                        print("Decoding error: \(error)")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }
                }
            }
    }

}
