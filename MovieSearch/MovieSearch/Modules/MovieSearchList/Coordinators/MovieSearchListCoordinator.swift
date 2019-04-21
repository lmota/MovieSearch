//
//  MovieSearchListCoordinator.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

/**
 * Module coordinator, navigating to the MovieSearchListViewController
 */
class MovieSearchListCoordinator : CoordinatorProtocol {
    
    var navigationController:UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let movieSearchListViewController = MovieSearchListViewController.instantiate()
        movieSearchListViewController.coordinator = self
        navigationController.pushViewController(movieSearchListViewController, animated: false)

    }
}

