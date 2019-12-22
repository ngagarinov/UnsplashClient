//
//  NetworkDataFetcher.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 19.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker

struct NetworkDataFetcher {
    
    // MARK: - Constants
    
    private enum Constants {
        static let perPageParameter = ["per_page" : "10"]
        static let page = "page"
        static let collections = "/collections"
        static let photos = "/photos/"
    }
    
    // MARK: - Properties
    let networking: Networking = NetworkService()
    
    // MARK: - Internal helpers
    
    func getCollections(withNext page: Int? = nil, response: @escaping ([Collections]?) -> Void) {
        var params = Constants.perPageParameter
        if let page = page {
            params = [Constants.page : "\(page)"]
        }
        networking.request(path: Constants.collections, params: params) { (data, error) in
            if let error = error {
                print("error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJson(type: [Collections].self, fromData: data)
            response(decoded)
        }
    }
    
    func getCollectionPhotos(withNext page: Int? = nil, collectonId: String, response: @escaping ([PhotoDetail]?) -> Void) {
        var params = Constants.perPageParameter
        if let page = page {
            params = [Constants.page : "\(page)"]
        }
        let path = Constants.collections + "/\(collectonId)" + Constants.photos
        networking.request(path: path, params: params) { (data, error) in
            if let error = error {
                print("error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJson(type: [PhotoDetail].self, fromData: data)
            response(decoded)
        }
    }
    
    func getPhotoDetail(id: String, response: @escaping (PhotoDetail?) -> Void) {
        networking.request(path: Constants.photos + id, params: [
            :]) { (data, error) in
            if let error = error {
                print("error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJson(type: PhotoDetail.self, fromData: data)
            response(decoded)
        }
    }
    
    // MARK: - Private Helpers
    
    private func decodeJson<T: Decodable>(type: T.Type, fromData: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = fromData, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
