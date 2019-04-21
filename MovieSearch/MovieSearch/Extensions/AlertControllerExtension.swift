//
//  AlertControllerExtension.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    /**
     * Extension on UIViewController for presenting alert
     */
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}
