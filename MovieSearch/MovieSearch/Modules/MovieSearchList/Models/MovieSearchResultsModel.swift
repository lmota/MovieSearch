//
//  MovieSearchResultsModel.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

struct MovieSearchResultsModel : Decodable {
    let title:String?
    let overview:String?
    let posterPath:String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
    }
    
    
}

struct MovieSearchListResponse : Decodable {
    
    let currentPage:Int
    let totalPages:Int
    let totalResults:Int
    let results:[MovieSearchResultsModel]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}
