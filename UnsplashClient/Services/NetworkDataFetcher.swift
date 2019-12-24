//
//  NetworkDataFetcher.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 19.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import Foundation

struct NetworkDataFetcher {
    
    // MARK: - Constants
    
    private enum Constants {
        static let perPageParameter = ["per_page" : "10"]
        static let page = "page"
        static let collections = "/collections"
        static let photos = "/photos/"
        static let PhotoOfTheDayCollectionId = "/1459961/"
    }
    
    // MARK: - Enum
    
    enum Result<ResultDataType> {
        case data(ResultDataType)
        case error
    }
    
    // MARK: - Properties
    let networking: Networking = NetworkService()
    
    // MARK: - Internal helpers
    
    func getCollections(withNext page: Int? = nil, response: @escaping (Result<[Collections]>) -> Void) {
        var params = Constants.perPageParameter
        if let page = page {
            params = [Constants.page : "\(page)"]
        }
        networking.request(path: Constants.collections, params: params) { (data, error) in
            guard let data = data, let decoded = self.decodeJson(type: [Collections].self, fromData: data) else {
                response(.error)
                return
            }
            response(.data(decoded))
        }
    }
    
    func getPhotoOfTheDay(response: @escaping (Result<Collections>) -> Void) {
        let path = Constants.collections + Constants.PhotoOfTheDayCollectionId
        networking.request(path: path, params: [:]) { (data, error) in
            guard let data = data, let decoded = self.decodeJson(type: Collections.self, fromData: data) else {
                response(.error)
                return
            }
            response(.data(decoded))
        }
    }
    
    func getCollectionPhotos(withNext page: Int? = nil, collectonId: String, response: @escaping (Result<[PhotoDetail]>) -> Void) {
        var params = Constants.perPageParameter
        if let page = page {
            params = [Constants.page : "\(page)"]
        }
        let path = Constants.collections + "/\(collectonId)" + Constants.photos
        networking.request(path: path, params: params) { (data, error) in
            guard let data = data, let decoded = self.decodeJson(type: [PhotoDetail].self, fromData: data) else {
                response(.error)
                return
            }
            response(.data(decoded))
        }
    }
    
    func getPhotoDetail(id: String, response: @escaping (Result<PhotoDetail>) -> Void) {
        networking.request(path: Constants.photos + id, params: [
            :]) { (data, error) in
                guard let data = data, let decoded = self.decodeJson(type: PhotoDetail.self, fromData: data) else {
                    response(.error)
                    return
                }
                response(.data(decoded))
        }
    }
    
    // MARK: - Private Helpers
    
    private func decodeJson<T: Decodable>(type: T.Type, fromData: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = fromData, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
