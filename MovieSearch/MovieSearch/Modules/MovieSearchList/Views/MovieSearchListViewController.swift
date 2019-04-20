//
//  MovieSearchListViewController.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class MovieSearchListViewController: UIViewController {
  
    private lazy var viewModel: MovieSearchListViewModel = {
        return MovieSearchListViewModel(dataManager: MovieSearchListDataManager())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpUI()
    }
    
    private func setUpUI(){
        self.navigationItem.title = viewModel.screenTitle

        
    }
    
    convenience init(viewModel: MovieSearchListViewModel) {
        self.init()
        self.viewModel = viewModel
    }


}

