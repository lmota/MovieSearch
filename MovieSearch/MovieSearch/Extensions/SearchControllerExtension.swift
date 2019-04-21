//
//  SearchControllerExtension.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/21/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

/**
 *  SearchController extension to customize search
 */
extension UISearchController {
    
    func customize() {
        
        // customizing few search controller attributes
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        
        //sets searchBar backgroundColor, barTintColor, barStyle
        self.searchBar.backgroundColor = Constants.searchBarBackgroundColor
        self.searchBar.barTintColor = Constants.searchBarTintColor
        self.searchBar.searchBarStyle = .prominent
        
        // gets the search field from the search bar
        guard let field = self.searchBar.value(forKey: Constants.searchFieldKey) as? UITextField,
            let iconView = field.leftView as? UIImageView else {
                return
        }
        
        //customize search field
        field.layer.cornerRadius = CGFloat(Constants.searchFieldCornerRadius)
        field.textColor = .darkGray
        field.font = UIFont.systemFont(ofSize: CGFloat(Constants.searchFieldFontSize))
        field.layer.masksToBounds = true
        field.returnKeyType = .search
        
        //sets search field attributed placeholder
        self.searchBar.placeholder = Constants.searchControllerPlaceholder.localizedCapitalized
        let placeholderString = NSAttributedString(string: Constants.searchControllerPlaceholder.localizedCapitalized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        field.attributedPlaceholder = placeholderString
        
        //sets search field icon
        iconView.image = UIImage(named:Constants.searchImage)
        
    }
}
