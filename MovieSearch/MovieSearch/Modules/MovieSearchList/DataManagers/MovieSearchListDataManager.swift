//
//  MovieSearchListDataManager.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

protocol MovieSearchListDataManagerProtocol {
    func fetchMovies(with request: MovieSearchRequest,
                     page: Int,
                     completion: @escaping (Result<MovieSearchListResponse, MovieSearchResponseError>) -> Void)
}

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}

class MovieSearchListDataManager : MovieSearchListDataManagerProtocol {
    
    private lazy var baseURL: URL? = {
        return URL(string: Constants.movieSearchAPIURL)
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /**
     * fetching Movies from IMDB
     * parameters : request - urlRequest, page - requested page number, completion - closure to execute once the response is received
     * return - nothing
     */
    func fetchMovies(with request: MovieSearchRequest, page: Int,
                              completion: @escaping (Result<MovieSearchListResponse, MovieSearchResponseError>) -> Void) {
        
        guard let baseURL = baseURL else{
            return
        }
        
        // requesting for next page
        let parameters = [Constants.pageParameter: "\(page+1)"].merging(request.parameters, uniquingKeysWith: +)

        let encodedURLRequest = URLRequest(url: baseURL).encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(MovieSearchResponseError.network))
                    return
            }
            
            do {
                
                let decodedResponse = try JSONDecoder().decode(MovieSearchListResponse.self, from: data)
                completion(Result.success(decodedResponse))
                
            } catch let error {
                Logger.logInfo(error.localizedDescription)
                completion(Result.failure(MovieSearchResponseError.decoding))
            }
            
        }).resume()
    }
    
}
