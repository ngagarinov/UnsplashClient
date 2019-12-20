//
//  Collections.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 19.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import Foundation

struct Collections: Decodable {
    let id: Int
    let title: String
    let previewPhotos: [PhotosCollection]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case previewPhotos = "preview_photos"
    }
}

struct PhotosCollection: Decodable {
    let id: String
    let urls: RegularPhoto
}

struct RegularPhoto: Decodable {
    let regular: String
}

struct PhotoDetail: Decodable {
    let width: Int
    let height: Int
    let description: String?
    let urls: RegularPhoto
}
