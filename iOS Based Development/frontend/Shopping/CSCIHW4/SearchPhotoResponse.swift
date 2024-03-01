//
//  SearchPhotoResponse.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/24/23.
//

import Foundation

struct SearchPhotoResponse: Codable {
    let items: [PhotoItem]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}

struct PhotoItem: Codable {
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case link = "link" 
    }
}
