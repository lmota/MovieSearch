//
//  MovieSearchTests.swift
//  MovieSearchTests
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import XCTest
@testable import MovieSearch

class MovieSearchTests: XCTestCase {

    private let movieSearchMockResponseFilename = "MovieSearchMockResponse"
    private lazy var viewModel:MovieSearchListViewModel = {
        
        let mockDataManager = MockDataManager(mockResponseFilename: movieSearchMockResponseFilename)
        return  MovieSearchListViewModel(dataManager: mockDataManager, delegate: nil, request:MovieSearchRequest.from(searchText: "Harry Potter"))
    }()

    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel.dataManager.fetchMovies(with: viewModel.movieSearchRequest, page: 1, completion: {result in
            self.viewModel.handleMovieSearchResult(result: result)
        })
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovieSearchListViewModelGetTitle() {
        
        let actualTitle = viewModel.getMovieTitle(at:0)
        let desiredTitle = "Harry Potter and the Philosopher's Stone"
        XCTAssertEqual(actualTitle, desiredTitle)
    }
    
    func testMovieSearchListViewModelGetTitleAtInvalidIndex() {
        let actualTitle = viewModel.getMovieTitle(at:27)
        XCTAssertNil(actualTitle)
    }
    
    func testMovieSearchListViewModelGetOverview() {
        
        let actualTitle = viewModel.getMovieOverview(at:0)
        let desiredTitle = "Harry Potter has lived under the stairs at his aunt and uncle's house his whole life. But on his 11th birthday, he learns he's a powerful wizard -- with a place waiting for him at the Hogwarts School of Witchcraft and Wizardry. As he learns to harness his newfound powers with the help of the school's kindly headmaster, Harry uncovers the truth about his parents' deaths -- and about the villain who's to blame."
        XCTAssertEqual(actualTitle, desiredTitle)
    }
    
    func testMovieSearchListViewModelGetOverviewAtInvalidIndex() {
        let actualOverview = viewModel.getMovieOverview(at:27)
        XCTAssertNil(actualOverview)
    }
    
    func testMovieSearchListViewModelGetPosterImageURLString() {
        
        let actualPosterImageURLString = viewModel.getPosterImageURLString(at:0)
        let desiredPosterImageURLString = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/dCtFvscYcXQKTNvyyaQr2g2UacJ.jpg"
        XCTAssertEqual(actualPosterImageURLString, desiredPosterImageURLString)
    }
    
    func testMovieSearchListViewModelGetPosterImageURLStringAtInvalidIndex() {
        let actualPosterImageURLString = viewModel.getPosterImageURLString(at:27)
        XCTAssertNil(actualPosterImageURLString)
    }

    func testCanProceedWithFetchingMovies(){
        XCTAssertTrue(viewModel.canProceedWithFetchingMovies())
    }
    
    func testDidFindResults(){
        XCTAssertTrue(viewModel.didFindResults())
    }
    
    func testIsMaxPageLimitReached(){
        XCTAssertFalse(viewModel.isMaxPageLimitReached())
    }
    
    func testShouldInsertAdditionalItems(){
        XCTAssertFalse(viewModel.shouldInsertAdditionalItems())
    }

    func handleMovieSearchResultSuccess(){
        XCTAssertTrue(viewModel.totalCount == 27)
        XCTAssertTrue(viewModel.totalPages == 2)
    }

    private class MockDataManager:MovieSearchListDataManagerProtocol {
        
        func fetchMovies(with request: MovieSearchRequest, page: Int, completion: @escaping (Result<MovieSearchListResponse, MovieSearchResponseError>) -> Void) {
            
            do {
                guard let response = MockResponse.data(fileName: mockResponseFilename) else {
                    return
                }
                let movieSearchResponse = try JSONDecoder().decode(MovieSearchListResponse.self, from: response)
                completion(Result.success(movieSearchResponse))
            } catch _ as NSError {
                completion(Result.failure(MovieSearchResponseError.decoding))
            }
            
        }
        
        
        private var mockResponseFilename: String
    
        init(mockResponseFilename: String) {
            self.mockResponseFilename = mockResponseFilename
        }

    }
}

class MockResponse {
    
    /*
     * This will return a dictionary from JSON file
     */
    static func dictionary(fileName: String) -> [String : Any]? {
        return MockResponse.loadFile(name: fileName, asArray: false) as? [String : Any]
    }
    
    /*
     * This will return an array from JSON file
     */
    static func array(fileName: String) -> [[String : Any]]? {
        return MockResponse.loadFile(name: fileName, asArray: true) as? [[String : Any]]
    }
    
    /*
     * This will return a data object from JSON file
     */
    static func data(fileName: String) -> Data? {
        var data: Data?
        if let arrayResponse = MockResponse.array(fileName: fileName) {
            data = try? JSONSerialization.data(withJSONObject: arrayResponse, options: [])
        } else if let dictionaryResponse = MockResponse.dictionary(fileName: fileName) {
            data = try? JSONSerialization.data(withJSONObject: dictionaryResponse, options: [])
        }
        return data
    }
    
    /*
     * This will return a data object from 'Any' object (ex.: Array, Dictionary, etc)
     */
    static func data(response: Any?) -> Data? {
        if let responseObject = response {
            return try? JSONSerialization.data(withJSONObject: responseObject, options: [])
        }
        return nil
    }
    
    private static func loadFile(name: String, asArray: Bool) -> AnyObject? {
        let bundle = Bundle(for: type(of: BundleTestClass()))
        if let path = bundle.path(forResource: name, ofType: "json") {
            do {
                // data object from json file
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                // try to serialize the json
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                // parse json as array
                if asArray == true {
                    if let arrayResult = jsonResult as? [[String : Any]] {
                        return arrayResult as AnyObject
                    } else { return nil }
                    
                    // parse json as dictionary
                } else if asArray == false {
                    if let dictionaryResult = jsonResult as? [String : Any] {
                        return dictionaryResult as AnyObject
                    } else { return nil }
                }
            } catch { return nil }
        }
        return nil
    }
    
    class BundleTestClass: XCTestCase { }
}





