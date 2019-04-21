//
//  MovieSearchListViewModel.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

/**
 *  MovieSearchListViewModelDelegate protocol declaration for the fetch completion functions
 */
protocol MovieSearchListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

/**
 *  MovieSearchListViewModel for the movie search list view
 */
class MovieSearchListViewModel {
    
    // MARK: vars for the view model
    private var movieResults = [MovieSearchResultsModel]()
    private var dataManager: MovieSearchListDataManager
    private var movieSearchRequest : MovieSearchRequest
    private weak var delegate : MovieSearchListViewModelDelegate?
    private var currentPage = 0
    private var total = 0
    private var isFetchInProgress = false
    private var hasReachedMaxPageLimit = false
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return movieResults.count
    }
    
    // MARK: Initializer
    init(dataManager: MovieSearchListDataManager, delegate: MovieSearchListViewModelDelegate, request:MovieSearchRequest) {
        self.dataManager = dataManager
        self.delegate = delegate
        self.movieSearchRequest = request
    }
    
    // MARK: fetching movie results for index
    
    /**
     *  fetch movie title for a particular index
     *  parameters - index
     *  returns - title at the index
     */
    func getMovieTitle(at index:Int)->String? {
        guard index < movieResults.count else { return nil }
        return movieResults[index].title
    }
    
    /**
     *  fetch movie overview for a particular index
     *  parameters - index
     *  returns - overview at the index
     */
    func getMovieOverview(at index:Int)->String? {
        guard index < movieResults.count else { return nil }
        return movieResults[index].overview
    }
    
    /**
     *  fetch movie posterImageURLString for a particular index
     *  parameters - index
     *  returns - posterImageURLString at the index
     */
    func getPosterImageURLString(at index:Int)->String? {
        
        guard index < movieResults.count else { return nil }
        
        let movieResult = movieResults[index]
        guard let posterPath = movieResult.posterPath, let posterImageBaseUrl = URL(string: Constants.moviePosterImageBaseURL) else{
            return nil
        }
        
        return posterImageBaseUrl.appendingPathComponent(posterPath).absoluteString
    }
    
    /**
     *  Check if we can proceed with fetching movies
     *  Parameters - none
     *  returns - Bool indicating if we can proceed with a fetch request
     */
    private func canProceedWithFetchingMovies() -> Bool {
        return !isFetchInProgress && !hasReachedMaxPageLimit
    }
    
    /**
     *  Check if we results were found for search
     *  Parameters - none
     *  returns - Bool indicating if any search results were found
     */
    private func didFindResults() -> Bool {
        return self.total > 0
    }
    
    /**
     *  Check if we reached maxPageLimit
     *  Parameters - response
     *  returns - Bool indicating if max limit is reached
     */
    private func isMaxPageLimitReached(response:MovieSearchListResponse) -> Bool {
        return self.currentPage == response.totalPages
    }
    
    /**
     *  Check if we should insert additional items to the table
     *  Parameters - none
     *  returns - Bool indicating if table should insert additional items
     */
    private func shouldInsertAdditionalItems() -> Bool {
        return self.currentPage > 1
    }
    
    /**
     * Handle the movie search result failure
     * Parameters - failure reason for the fetch
     */
    private func handleMovieSearchResultFailure(reason:String) {
        self.isFetchInProgress = false
        self.delegate?.onFetchFailed(with: reason)
    }
    
    /**
     * Handle search result success
     * parameters - response received from server
     */
    private func handleMovieSearchResultSuccess(response: MovieSearchListResponse) {
        
        self.currentPage = response.currentPage
        self.isFetchInProgress = false
        
        self.movieResults.append(contentsOf: response.results)
        self.total = self.movieResults.count
        
        guard self.didFindResults() else {
            self.delegate?.onFetchFailed(with:Constants.searchFailureAlertText.localizedCapitalized)
            return
        }
        
        // check if the current page is equal to the total pages, if yes, we have reached max page limit
        if self.isMaxPageLimitReached(response: response) {
            self.hasReachedMaxPageLimit = true
        }
        
        // if current page is greater than one then we want to insert the additional items
        if self.shouldInsertAdditionalItems() {
            
            let indexPathsToReload = self.calculateIndexPathsToReload(from: response.results)
            self.delegate?.onFetchCompleted(with: indexPathsToReload)
            
        } else {
            
            // if current page is first page then we need to reload the table
            self.delegate?.onFetchCompleted(with: .none)
        }
    }
    
    
    /**
     * Handle the movie search result
     */
    private func handleMovieSearchResult(result:Result<MovieSearchListResponse, MovieSearchResponseError>){
        
        switch result {
            // handle the failure for fetch
            case .failure(let error):
                self.handleMovieSearchResultFailure(reason: error.reason)
            
            // handle the success for the fetch
            case .success(let response):
                self.handleMovieSearchResultSuccess(response: response)
        }
    }
    
    /**
     *  fetching the movies from backend
     *  parameters - none
     *  returns - none
     */
    func fetchMovies() {
        
        // since this method is called multiple times when user scrolls to the bottom of the table, we need to ensure that a fetch is not in pogress and we have not reached maximum page limit
        guard canProceedWithFetchingMovies() else {
            return
        }
        
        isFetchInProgress = true
        
        // invoke the data manager to initiate the fetch request
        dataManager.fetchMovies(with: movieSearchRequest, page: currentPage) { result in
            DispatchQueue.main.async { [weak self] in
                
                // handle the movie search result
                self?.handleMovieSearchResult(result: result)

            }
        }
    }
    
    /**
     *  Utility method to compute the index paths that need to be reloaded
     *  parameters - newMovieResults array
     *  returns - array of indexPaths to be reloaded
     */
    private func calculateIndexPathsToReload(from newMovieResults: [MovieSearchResultsModel]) -> [IndexPath]{
        let startIndex = movieResults.count - newMovieResults.count
        let endIndex = startIndex + newMovieResults.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
