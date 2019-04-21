//
//  SearchControllerExtension.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/21/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

extension UISearchController {
    
    func customize() {
        self.searchBar.placeholder = Constants.searchControllerPlaceholder.localizedCapitalized
        
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        
        //sets searchBar backgroundColor and barTintColor
        self.searchBar.backgroundColor = Constants.searchBarBackgroundColor
        self.searchBar.barTintColor = Constants.searchBarTintColor
        self.searchBar.searchBarStyle = .prominent
        
        guard let field = self.searchBar.value(forKey: Constants.searchFieldKey) as? UITextField,
            let iconView = field.leftView as? UIImageView else {
                return
        }
        
        field.layer.cornerRadius = CGFloat(Constants.searchFieldCornerRadius)
        
        //sets text Color
        field.textColor = .darkGray
        field.font = UIFont.systemFont(ofSize: CGFloat(Constants.searchFieldFontSize))
        field.layer.masksToBounds = true
        field.returnKeyType = .search
        
        //sets placeholder text Color
        let placeholderString = NSAttributedString(string: Constants.searchControllerPlaceholder.localizedCapitalized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        field.attributedPlaceholder = placeholderString
        
        //sets icon Color
        iconView.image = UIImage(named:Constants.searchImage)
        
    }
}
