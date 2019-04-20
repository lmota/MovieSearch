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
    
    fileprivate enum movieSearchListTableViewCellStates{
        case viewModelNotSet
        case viewModelSet
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        posterImageView.createRoundedBorder()
        self.contentView.backgroundColor = Constants.backgroundColor
    }
    
    fileprivate func updateUI(for cellState:movieSearchListTableViewCellStates){
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
        
        posterImageView.image = UIImage(named:Constants.defaultPosterImageName)
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
        
        guard let posterImageURLString = viewModel.getPosterImageURLString(at: index) else {
            updateUI(for: .viewModelSet)
            return
        }
        
        cacheImage(urlString:posterImageURLString)
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension movieSearchListTableViewCell {
    func cacheImage(urlString: String){
        
        guard let url = URL(string: urlString) else {return}
        
        posterImageView.image = UIImage(named: Constants.defaultPosterImageName)
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            posterImageView.image = imageFromCache
            updateUI(for: .viewModelSet)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let imageData = data  else {
                self?.updateUI(for: .viewModelSet)
                return
                
            }
            DispatchQueue.main.async { [weak self] in
                guard let imageToCache = UIImage(data: imageData) else {
                    self?.updateUI(for: .viewModelSet)
                    return
                }
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self?.posterImageView.image = imageToCache
                self?.updateUI(for: .viewModelSet)
            }
            
        }.resume()
    }
}
