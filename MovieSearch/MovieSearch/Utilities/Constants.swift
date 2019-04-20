//
//  MovieSearchConstants.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

/**
 * Struct for constants used in the application
 */
struct Constants{

    static let imageViewCornerRadius = 5.0
    static let backgroundColor = UIColor(red:0.925, green: 1.0, blue: 1.0, alpha: 1)
    static let movieSearchAPIPath = "search"
    static let movieSearchAPIKeyParameter = "api_key"
    static let movieSearchAPIKeyValue = "2a61185ef6a27f400fd92820ad9e8537" // need to store it in keychain?
    static let movieSearchApiParameter = "query"
    static let movieSearchAPIURL = "https://api.themoviedb.org/3/search/movie"
    static let moviePosterImageBaseURL = "https://image.tmdb.org/t/p/w600_and_h900_bestv2"
    static let movieSearchListTableViewEstimatedRowHeight = 180.0
    static let pageParameter = "page"
}
