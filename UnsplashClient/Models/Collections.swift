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
    let description: String?
    let totalPhotos: Int
    let coverPhoto: PhotosCollection
    let previewPhotos: [PhotosCollection]
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description
        case totalPhotos = "total_photos"
        case coverPhoto = "cover_photo"
        case previewPhotos = "preview_photos"
    }
}

struct PhotosCollection: Decodable {
    let id: String
    let urls: ImageSizes
    let user: UserName?
}

struct UserName: Decodable {
    let name: String?
}

struct ImageSizes: Decodable {
    let small: String
    let regular: String
    let full: String
}

struct PhotoDetail: Decodable {
    let width: Int
    let height: Int
    let description: String?
    let urls: ImageSizes
    let user: UserName?
}

