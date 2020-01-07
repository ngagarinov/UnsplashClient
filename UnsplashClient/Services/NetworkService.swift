//
//  NetworkService.swift
//  UnsplashClient
//
//  Created by Никита Гагаринов on 19.12.2019.
//  Copyright © 2019 nikita. All rights reserved.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {
    
    // MARK: - Constants
    
    private enum Constants {
        static let scheme = "https"
        static let host = "api.unsplash.com"
        static let clientIdParam = "client_id"
    }
    
    // MARK: - Internal Helpers
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        var allParams = params
        allParams[Constants.clientIdParam] = SecretConstants.accessKey
        if let url = self.url(from: path, params: allParams) {
            let request = URLRequest(url: url)
            let task = createDataTask(from: request, completion: completion)
            task.resume()
        }
    }
    
     private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void ) -> URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data,error)
            }
        })
    }
    
    // MARK: - Private Helpers
    
    private func url(from path: String, params: [String: String]) -> URL? {
        
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}

        return components.url
    }
}
