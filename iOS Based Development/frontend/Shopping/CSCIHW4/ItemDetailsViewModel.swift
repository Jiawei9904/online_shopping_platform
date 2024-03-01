//
//  ItemDetailsViewModel.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/22/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class ItemDetailsViewModel: ObservableObject {
    @Published var itemDetails: ItemDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var googlePhotos: [URL] = []
    @Published var similarItems: [SimilarItem] = []
    func fetchItemDetails(itemId: String) {
        isLoading = true
        errorMessage = nil

        let urlString = "https://hw3ebayadvanced.wl.r.appspot.com/getItemDetails/\(itemId)"

        AF.request(urlString).responseData { response in
            DispatchQueue.main.async {
                self.isLoading = false

                switch response.result {
                case .success(let data):
                    // use SwifyJSON to decode the data
                    let json = JSON(data)
                    if let itemJson = json["Item"].dictionary {
                        self.itemDetails = ItemDetails(json: JSON(itemJson))
                    } else {
                        self.errorMessage = "Failed to parse item details"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        
    }
    
    func shareOnFacebook(completion: @escaping (URL?) -> Void) {
            guard let itemDetails = itemDetails else {
                self.errorMessage = "Item details are not available"
                completion(nil)
                return
            }
            
            let productName = itemDetails.title
            let price = itemDetails.currentPrice.value
            let link = itemDetails.originalJSON["ViewItemURLForNaturalSearch"].string ?? ""
            
            let parameters: [String: Any] = [
                "productName": productName,
                "price": price,
                "link": link
            ]
            
            AF.request("https://swiftbackend-406401.wl.r.appspot.com/api/generateFacebookShareLink",
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default).responseJSON { [weak self] response in
                switch response.result {
                case .success(let value):
                    if let responseDict = value as? [String: Any],
                       let shareUrl = responseDict["shareUrl"] as? String,
                       let url = URL(string: shareUrl) {
                        completion(url)
                    } else {
                        self?.errorMessage = "Error: Invalid response"
                        completion(nil)
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to generate Facebook share link: \(error.localizedDescription)"
                    completion(nil)
                }
            }
        }
    

    func fetchGooglePhotos(for title: String) {
        isLoading = true
        let urlString = "https://swiftbackend-406401.wl.r.appspot.com/searchImages/\(title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        AF.request(urlString).responseData { response in
            DispatchQueue.main.async {
                self.isLoading = false
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let photoResponse = try? decoder.decode(SearchPhotoResponse.self, from: data) {
                        self.googlePhotos = photoResponse.items.compactMap { item in
                            URL(string: item.link)
                        }
                    } else {
                        print("JSON 解析失败，数据格式可能不匹配。")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchSimilarItems(itemId: String) {
        
        isLoading = true
        
        let urlString = "https://swiftbackend-406401.wl.r.appspot.com/getSimilarItems/\(itemId)"
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                
                self.parseSimilarItems(jsonData: data)
            case .failure(let error):
                self.isLoading = false
                print(error)
            }
        }
    }
    func parseSimilarItems(jsonData: Data) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(SimilarItemsResponse.self, from: jsonData)
            // 更新你的UI或状态变量
            DispatchQueue.main.async {
                self.isLoading = false
                self.similarItems = response.getSimilarItemsResponse.itemRecommendations.item
                print(self.similarItems)
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }

}

