//
//  MovieSearchResponseError.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

/**
 * enumeration for the response failure.
 */
enum MovieSearchResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching the movie results".localizedCapitalized
        case .decoding:
            return "Internal error occured while fetching the movie results".localizedCapitalized
        }
    }
}
