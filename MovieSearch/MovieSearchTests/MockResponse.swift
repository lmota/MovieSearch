//
//  MockResponse.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/21/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import XCTest

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

