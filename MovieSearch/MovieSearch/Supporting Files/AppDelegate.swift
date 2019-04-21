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
        
        // Customizing the app launch using Coordinator design pattern
        let navController = UINavigationController()
        appCoordinator = MovieSearchAppCoordinator(navigationController: navController)
        appCoordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        // Customizing the navigation bar appearance
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().barStyle = .blackTranslucent
       
        return true
    }



}

