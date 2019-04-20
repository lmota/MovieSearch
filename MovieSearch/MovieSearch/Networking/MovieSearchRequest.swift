//
//  MovieSearchRequest.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

struct MovieSearchRequest {
    var path: String {
        return Constants.movieSearchAPIPath
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension MovieSearchRequest {
    /**
     * static function to form the request
     * parameter searchText - path of the request
     * return MovieSearchRequest - request to be sent for the apis
     */
    static func from(searchText: String) -> MovieSearchRequest {
        let defaultParameters = [Constants.movieSearchAPIKeyParameter: Constants.movieSearchAPIKeyValue]
        let parameters = [Constants.movieSearchApiParameter: "\(searchText)"].merging(defaultParameters, uniquingKeysWith: +)
        return MovieSearchRequest(parameters: parameters)
    }
}
