//
//  MovieSearchAppCoordinator.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    func start()
}

class MovieSearchAppCoordinator: CoordinatorProtocol {
    
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        MovieSearchListCoordinator(window: self.window).start()
    }
}
