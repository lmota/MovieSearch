//
//  MovieSearchListCoordinator.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

class MovieSearchListCoordinator : CoordinatorProtocol {
    
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let movieSearchListViewModel = MovieSearchListViewModel(dataManager: MovieSearchListDataManager())
        let movieSearchListViewController = MovieSearchListViewController(viewModel:movieSearchListViewModel)
        let navigationController = UINavigationController(rootViewController: movieSearchListViewController)
        window?.rootViewController = navigationController
    }
    
}
