//
//  MovieSearchAppCoordinator.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

/**
 * A generic coordinator protocol.
 * A coordinator is a construct has the following responsibilities:
 * - Instantiate the next scene's viewController
 * - Inject dependencies into the viewController
 * - Add the viewController to the window either by adding it on the UINavigationController or a UITabBarController
 */
public protocol CoordinatorProtocol {
    
    var navigationController: UINavigationController { get set }
    
    /**
     * starts the navigation flow:
     * Instantiates the next viewController
     * Injects all the dependency in the viewController
     * Adds the viewController on the window (usually through UINavigationController or UITabBarController)
     */
    func start()

}

/**
 * AppCoordinator, starting the module - MovieSearchListCoordinator
 */
class MovieSearchAppCoordinator: CoordinatorProtocol {

    var navigationController: UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        MovieSearchListCoordinator(navigationController: navigationController).start()
    }
}
