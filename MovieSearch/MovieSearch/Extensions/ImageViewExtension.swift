//
//  ImageViewExtension.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /**
     * UIImageView extension to create rounded border
     */
    func createRoundedBorder(){
        self.layer.cornerRadius = CGFloat(Constants.imageViewCornerRadius)
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
    }
    
}
