//
//  movieSearchListTableViewCell.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

/**
 *  Custom table view cell for movie search results list view
 */
class movieSearchListTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    // MARK: Enumerations
    fileprivate enum movieSearchListTableViewCellStates{
        case viewModelNotSet
        case viewModelSet
    }
    
    // MARK: Custom cell initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        posterImageView.createRoundedBorder()
        self.contentView.backgroundColor = Constants.backgroundColor
    }
    
    // MARK: Update UI for customCell based on the state
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
    
    // MARK: CustomCell preparation for reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = UIImage(named:Constants.defaultPosterImageName)
        spinner.stopAnimating()
        movieTitle.text = ""
        movieOverview.text = ""
    }

    // Custom cell configuration from viewModel for the indexpath
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
        
        // cache the poster image using NSCache
        cacheImage(urlString:posterImageURLString, imageView: posterImageView)
    }
}

// MARK: Extension for ImageCaching

let imageCache = NSCache<AnyObject, AnyObject>()

/**
 * movieSearchListTableViewCell extension to implement Image caching for the imageview
 */
extension movieSearchListTableViewCell {

    
    func cacheImage(urlString: String, imageView: UIImageView) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        //setting the imageCacheCountLimit
        imageCache.countLimit = Constants.imageCacheCountLimit
        
        // setting the default poster image
        imageView.image = UIImage(named: Constants.defaultPosterImageName)
        
        // check of the image is available in the cache, if yes, use the cached image
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            imageView.image = imageFromCache
            updateUI(for: .viewModelSet)
            return
        }
        
        // If cache is unavailable, fetch the image from network on a background thread using URLSession dataTask
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            // Once we get the response, switch back to main thread to update ui
             DispatchQueue.main.async { [weak self] in
                
                // if no image found then update the UI
                guard let imageData = data, let imageToCache = UIImage(data: imageData)  else {
                    self?.updateUI(for: .viewModelSet)
                    return
                }

                // If image received, set it in the cache and update ui
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                imageView.image = imageToCache
                self?.updateUI(for: .viewModelSet)
            }
        }.resume()
    }
}
