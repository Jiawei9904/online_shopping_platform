//
//  PostalCodeFetcher.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/14/23.
//

import Foundation

// 用于解析API响应中每个条目的结构体
struct PostalCodeEntry: Codable {
    var postalCode: String
}

// 用于解析整个API响应的结构体
struct PostalCodeResponse: Codable {
    var postalCodes: [PostalCodeEntry]
}

class PostalCodeFetcher: ObservableObject {
    @Published var postalCodeSuggestions: [String] = []

    func fetchPostalCodeSuggestions(for prefix: String) {
        guard !prefix.isEmpty, prefix.count >= 4 else {
            self.postalCodeSuggestions = []
            return
        }

        let urlString = "https://swiftbackend-406401.wl.r.appspot.com/api/postalCodeSearch?postalcode_startsWith=\(prefix)&maxRows=5"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, error == nil {
                do {
                    let decodedResponse = try JSONDecoder().decode(PostalCodeResponse.self, from: data)
                    DispatchQueue.main.async {
                        // 提取postalCode字段并更新postalCodeSuggestions数组
                        self?.postalCodeSuggestions = decodedResponse.postalCodes.map { $0.postalCode }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.postalCodeSuggestions = []
                    }
                    print("JSON fetch failed: \(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.postalCodeSuggestions = []
                }
                print("Network request failure: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}






