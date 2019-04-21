//
//  URLRequestExtension.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

extension URLRequest {
    
    /**
     * Extenstion for URLRequest to encode the urlRequest with parameters
     * parameters - input dictionary of type [String:String] to be added to the urlRequest
     * return - encoded url request
     */
    func encode(with parameters: Parameters?) -> URLRequest {
        guard let parameters = parameters else {
            return self
        }
        
        var encodedURLRequest = self
        
        if let url = self.url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
            var newUrlComponents = urlComponents
            
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            
            newUrlComponents.queryItems = queryItems
            encodedURLRequest.url = newUrlComponents.url
            return encodedURLRequest
        
        } else {
            return self
        }
    }
}
