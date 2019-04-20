//
//  MovieSearchListViewModel.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

// protocol declaration for the fetch completion functions
protocol MovieSearchListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class MovieSearchListViewModel {
    
    private var movieResults = [MovieSearchResultsModel]()
    private var dataManager: MovieSearchListDataManager
    private var movieSearchRequest : MovieSearchRequest
    private weak var delegate : MovieSearchListViewModelDelegate?
    
    private var currentPage = 0
    private var total = 0
    private var isFetchInProgress = false
    private var hasReachedMaxPageLimit = false
    
    
    init(dataManager: MovieSearchListDataManager, delegate: MovieSearchListViewModelDelegate, request:MovieSearchRequest) {
        self.dataManager = dataManager
        self.delegate = delegate
        self.movieSearchRequest = request
    }
        
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return movieResults.count
    }
    
    func movieResultModel(at index: Int) -> MovieSearchResultsModel? {
        guard index < movieResults.count else {return nil}
        return movieResults[index]
    }
    
    func getMovieTitle(at index:Int)->String? {
        guard index < movieResults.count else { return nil }
        return movieResults[index].title
    }
    
    func getMovieOverview(at index:Int)->String? {
        guard index < movieResults.count else { return nil }
        return movieResults[index].overview
    }
    
    func getPosterImageURL(at index:Int)->URL? {
        
        guard index < movieResults.count else { return nil }
        
        let movieResult = movieResults[index]
        guard let posterPath = movieResult.posterPath, let posterImageBaseUrl = URL(string: Constants.moviePosterImageBaseURL) else{
            return nil
        }
        
        return posterImageBaseUrl.appendingPathComponent(posterPath)
    }
    
    // fetching the movies from backend
    func fetchMovies() {
        
        // since this method is called multiple times when user scrolls to the bottom of the table, we need to ensure that a fetch is not in pogress and we have not reached maximum page limit
        guard !isFetchInProgress, !hasReachedMaxPageLimit else {
            return
        }
        
        isFetchInProgress = true
        
        dataManager.fetchMovies(with: movieSearchRequest, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else {return}
                    
                    self.currentPage = response.currentPage
                    self.isFetchInProgress = false
                    
                    self.movieResults.append(contentsOf: response.results)
                    self.total = self.movieResults.count
                    
                    // check if the current page is equal to the total pages, if yes, we have reached max page limit
                    if self.currentPage == response.totalPages {
                        self.hasReachedMaxPageLimit = true
                    }
                    
                    // if current page is greater than one then we want to insert the additional items
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.results)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else { // if current page is first page then we need to reload the table
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    // utility method to compute the index paths that need to be reloaded
    private func calculateIndexPathsToReload(from newMovieResults: [MovieSearchResultsModel]) -> [IndexPath]{
        let startIndex = movieResults.count - newMovieResults.count
        let endIndex = startIndex + newMovieResults.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
