//
//  MovieSearchListViewModel.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

class MovieSearchListViewModel {
    
    private var movieResults = [MovieSearchResultsModel]()
    private var dataManager: MovieSearchListDataManager
    
    init(dataManager: MovieSearchListDataManager) {
        self.dataManager = dataManager
    }
    
    private (set) var screenTitle = "Movie Search".localizedCapitalized
    

    
    
}
