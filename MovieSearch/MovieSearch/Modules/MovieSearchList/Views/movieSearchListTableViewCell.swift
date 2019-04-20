//
//  movieSearchListTableViewCell.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class movieSearchListTableViewCell: UITableViewCell {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    private enum movieSearchListTableViewCellStates{
        case viewModelNotSet
        case viewModelSet
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        posterImageView.createRoundedBorder()
        self.contentView.backgroundColor = Constants.backgroundColor
    }
    
    private func updateUI(for cellState:movieSearchListTableViewCellStates){
        switch cellState {
            case .viewModelNotSet:
                movieTitle.isHidden = true
                movieOverview.isHidden = true
                posterImageView.isHidden = true
                spinner.startAnimating()
            
            case .viewModelSet:
                movieTitle.isHidden = false
                movieOverview.isHidden = false
                posterImageView.isHidden = false
                spinner.stopAnimating()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = UIImage(named: "DefaultMovieImage")
        spinner.stopAnimating()
        movieTitle.text = ""
        movieOverview.text = ""
    }

    func configure(at index:Int, viewModel:MovieSearchListViewModel?) {
        
        guard let viewModel = viewModel else {
            updateUI(for: .viewModelNotSet)
            return
        }

        guard let title = viewModel.getMovieTitle(at:index) else {
            return
        }
        movieTitle.text = title
        
        guard let overView = viewModel.getMovieOverview(at:index) else {
            return
        }
        movieOverview.text = overView
        
        guard let posterImageURL = viewModel.getPosterImageURL(at: index) else {
            updateUI(for: .viewModelSet)
            return
        }
        
        // need to implement image caching
        DispatchQueue.global(qos:.background).async {
            
            if let data = try? Data(contentsOf: posterImageURL) {
                DispatchQueue.main.async { [weak self] in
                    // once we have the data go back to main thread and load the image view
                    self?.posterImageView.image = UIImage(data: data)
                    self?.updateUI(for: .viewModelSet)
                }
            }
        }
  
    }

}
