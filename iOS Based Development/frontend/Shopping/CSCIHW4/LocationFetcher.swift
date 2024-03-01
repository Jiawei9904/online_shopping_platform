//
//  LocationFetcher.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/14/23.
//

import Foundation

class LocationFetcher: ObservableObject {
    @Published var currentLocation: String = ""

    func getCurrentLocation() {
        guard let url = URL(string: "https://ipinfo.io/json?token=185a4a40a11ba5") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let response = try? JSONDecoder().decode(LocationResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.currentLocation = response.postal // 例如，假设我们关注城市
                    }
                } else {
                    print("JSON fetch failed")
                }
            } else {
                print("Network request failure: \(error?.localizedDescription ?? "Unknown error")")
            }
        }

        task.resume()
    }
}

struct LocationResponse: Codable {
    var postal: String
}

