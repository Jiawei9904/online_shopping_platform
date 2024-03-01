//
//  SearchViewModel.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/15/23.
//

import Foundation
import Combine
import Alamofire
import SwiftyJSON
class SearchViewModel: ObservableObject {
    // Input properties
    @Published var keyword: String = ""
    @Published var selectedCategory: String = "All"
    @Published var conditionUsed: Bool = false
    @Published var conditionNew: Bool = false
    @Published var conditionUnspecified: Bool = false
    @Published var shippingPickup: Bool = false
    @Published var shippingFree: Bool = false
    @Published var customLocation: Bool = false
    @Published var zipcode: String = ""
    @Published var distance: String = "10"
    @Published var postalCodeSuggestions: [String] = []
    @Published var currentLocation: String = ""
    @Published var showSearchResults = false // determine if show result or not
    @Published var isDistanceEdited: Bool = false
    
    // Output properties
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    // check if no result
    @Published var noResults: Bool = false
    
    // Services
    var locationFetcher = LocationFetcher()
    var postalCodeFetcher = PostalCodeFetcher()
    
    // Computed properties
    var finalZipcode: String {
        customLocation ? zipcode : locationFetcher.currentLocation
    }
    
    var isZipCodeValid: Bool {
        !zipcode.isEmpty && zipcode.allSatisfy { $0.isNumber } && zipcode.count < 5 && zipcode.count >= 4
    }
    
    var isFinalZipCodeValid: Bool {
        finalZipcode.allSatisfy { $0.isNumber } && finalZipcode.count == 5
    }
    
    let categoryValues: [String: String] = [
            "All": "default",
            "Art": "550",
            "Baby": "2984",
            "Books": "267",
            "Clothing, Shoes & Accessories": "11450",
            "Computers/Tablets & Networking": "58058",
            "Health & Beauty": "26395",
            "Music": "11233",
            "Video Games & Consoles": "1249"
        ]
    
    // For general search result item
    @Published var searchResults = [SearchResultItem]()
    
    // Functions
    init() {
        getCurrentLocation()
        
    }

    func getCurrentLocation() {
        locationFetcher.getCurrentLocation()
        locationFetcher.$currentLocation
            .assign(to: &$currentLocation)
    }
    
    func fetchPostalCodeSuggestions(for prefix: String) {
        postalCodeFetcher.fetchPostalCodeSuggestions(for: prefix)
        // 监听 postalCodeSuggestions 的变化
        postalCodeFetcher.$postalCodeSuggestions
            .assign(to: &$postalCodeSuggestions)
        }
    func onSearchSubmit() {
        distance = distance.trimmingCharacters(in: .whitespacesAndNewlines)
        if distance.isEmpty {
            distance = "10"
        }
        if keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Keyword is mandatory"
            showErrorAlert = true
        } else if !isFinalZipCodeValid {
            errorMessage = "Valid zipcode is mandatory"
            showErrorAlert = true
        } else {
            showErrorAlert = false
            isLoading = true
            print("isLoading set to true")
            // convert data
            self.showSearchResults = true
            let dataToSend = convertToFrontendData()
            // send to the backend
            sendToBackend(data: dataToSend)
            
        }
    }
    
    private func convertToFrontendData() -> [String: Any] {
        var conditions: [String] = []
        if conditionNew { conditions.append("New") }
        if conditionUsed { conditions.append("Used") }
        if conditionUnspecified { conditions.append("Unspecified") }
        
        // jsonfy conditions
        let jsonConditions: String
        do {
            // Convert the conditions array to a JSON string
            let jsonData = try JSONSerialization.data(withJSONObject: conditions)
            jsonConditions = String(data: jsonData, encoding: .utf8) ?? "[]"
        } catch {
            print("Failed to encode conditions: \(error)")
            jsonConditions = "[]"
        }
        // check if distance is empty
        
        var data: [String: Any] = [
            "keywords": keyword,
            "conditions": jsonConditions,
            "postalCode": finalZipcode,
            "maxDistance": distance
        ]

        // 处理选项类型的数据
        if shippingFree {
            data["shippingOptions"] = "free"
        }
        if shippingPickup {
            data["localPickup"] = "localPickup"
        }
        if let categoryValue = categoryValues[selectedCategory] {
                data["category"] = categoryValue
        }
        print(data)
        return data
    }

    // need debug
    private func sendToBackend(data: [String: Any]) {
        AF.request("https://swiftbackend-406401.wl.r.appspot.com/search", method: .get, parameters: data)
            .validate()
            .responseData { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let data):
                        self.processJsonData(data)
                        self.isLoading = false
                        print("isLoading set to false after success")
                    case .failure(let error):
                        self.errorMessage = "Network error: \(error.localizedDescription)"
                        self.showErrorAlert = true
                        self.isLoading = false
                        print("isLoading set to false after success")
                    }
                }
            }
    }
    private func processJsonData(_ data: Data) {
        let json = JSON(data)
        if let items = json["findItemsAdvancedResponse"][0]["searchResult"][0]["item"].array {
            DispatchQueue.main.async {
                self.searchResults = items.compactMap { SearchResultItem(json: $0) }
                // print to test
                print("In search view model",self.searchResults)
            }
        } else {
            DispatchQueue.main.async {
                self.noResults = true
            }
        }
    }

    func clearForm() {
        self.keyword = ""
        self.selectedCategory = "All"
        self.conditionUsed = false
        self.conditionNew = false
        self.conditionUnspecified = false
        self.shippingPickup = false
        self.shippingFree = false
        self.distance = "10"
        self.customLocation = false
        self.showSearchResults = false
        self.noResults = false
        self.zipcode = ""
        self.isLoading = false
        self.isDistanceEdited = false
    }


}
