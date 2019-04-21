//
//  StoryBoardExtension.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/21/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let fullname = NSStringFromClass(self)
        let classname = fullname.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: classname) as! Self
    }
}
