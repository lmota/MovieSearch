//
//  HTTPURLResponseExtension.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    // extension to HTTPURLResponse for success status codes.
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
