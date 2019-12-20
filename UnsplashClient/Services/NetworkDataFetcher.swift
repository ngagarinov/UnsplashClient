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
        static let perPageParameter = ["per_page" : "20"]
        static let page = "page"
        static let collections = "/collections"
    }
    
    // MARK: - Properties
    let networking: Networking = NetworkService()
    
    // MARK: - Internal helpers
    
    func getCollections(response: @escaping ([Collections]?) -> Void) {
        let params = Constants.perPageParameter
        networking.request(path: Constants.collections, params: params) { (data, error) in
            if let error = error {
                print("error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJson(type: [Collections].self, fromData: data)
            response(decoded)
        }
    }
    
    func getNextCollection(page: Int, response: @escaping ([Collections]?) -> Void) {
        var params = Constants.perPageParameter
        params = [Constants.page : "\(page)"]
        networking.request(path: Constants.collections, params: params) { (data, error) in
            if let error = error {
                print("error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJson(type: [Collections].self, fromData: data)
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
