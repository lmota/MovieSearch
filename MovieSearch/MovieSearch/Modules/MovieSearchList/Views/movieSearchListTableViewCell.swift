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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        posterImageView.createRoundedBorder()
        self.contentView.backgroundColor = Constants.backgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = UIImage(named: "DefaultMovieImage")
    }

    func configure(at index:Int, viewModel:MovieSearchListViewModel?) {
        if let viewModel = viewModel {
            
//            self.spinner.startAnimating()
            
            guard let title = viewModel.getMovieTitle(at:index) else {
                return
            }
            movieTitle.text = title
            movieTitle.isHidden = false
            
            guard let overView = viewModel.getMovieOverview(at:index) else {
                return
            }
            movieOverview.text = overView
            movieOverview.isHidden = false
            
            guard let posterImageURL = viewModel.getPosterImageURL(at: index) else {
                return
            }
            
            // need to implement image caching
            DispatchQueue.global(qos:.background).async {
                
                    if let data = try? Data(contentsOf: posterImageURL) {
                        DispatchQueue.main.async { [weak self] in
                            // once we have the data go back to main thread and load the image view
                            self?.posterImageView.image = UIImage(data: data)
                            self?.spinner.stopAnimating()
                        }
                    }
            }
            
        } else {
            
            movieTitle.isHidden = true
            movieOverview.isHidden = true
            posterImageView.isHidden = true
            spinner.startAnimating()
            
        }
    }

}
