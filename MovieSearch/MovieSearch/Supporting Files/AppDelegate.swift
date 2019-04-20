//
//  AppDelegate.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: MovieSearchAppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
//        appCoordinator = MovieSearchAppCoordinator(window: window)
//        appCoordinator?.start()
        
        // Customizing the navigation bar appearance
        UINavigationBar.appearance().barTintColor = Constants.backgroundColor
        UINavigationBar.appearance().barStyle = .default
        
        return true
    }



}

