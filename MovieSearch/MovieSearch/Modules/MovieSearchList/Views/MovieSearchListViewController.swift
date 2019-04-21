//
//  MovieSearchListViewController.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

/**
 * MovieSearchListViewController - Displaying the movie results and search controller to find movies
 */

class MovieSearchListViewController: UIViewController, UITableViewDelegate, Storyboarded {
  
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieListViewControllerSpinner: UIActivityIndicatorView!
    @IBOutlet weak var informatoryLabel: UILabel!
    
    // MARK: vars
    private var viewModel: MovieSearchListViewModel?
    weak var coordinator: MovieSearchListCoordinator?
    
    lazy var searchController:  UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    fileprivate var searchText: String? {
        didSet {
            guard let queryText = searchText else { return }
            
            if !queryText.isEmpty{
                searchController.searchBar.text = queryText
                searchController.searchBar.placeholder = queryText
                
                self.updateUI(for: .searchBegan)
                let request = MovieSearchRequest.from(searchText:queryText)
                
                viewModel = MovieSearchListViewModel(dataManager: MovieSearchListDataManager(), delegate: self, request: request)
                viewModel?.fetchMovies()
            }
        }
    }
    
    // MARK: enumerations
    
    private enum identifiers {
        static let listCellIdentifier = "customCell"
    }
    
    private enum movieSearchListViewControllerStates:Int {
        case searchNotStarted
        case searchBegan
        case searchEndedWithResults
        case searchFailedWithoutResults
    }

    // MARK: UI Setup functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpUI()
    }
    
    /**
     *  private function to set up the UI for the view Controller
     */
    private func setUpUI(){
        self.navigationItem.title = Constants.screenTitle.localizedUppercase
        self.view.backgroundColor = Constants.backgroundColor
        informatoryLabel.text = Constants.informationLabelText.localizedCapitalized
        self.movieListViewControllerSpinner.stopAnimating()
        self.setUpTableView()
        searchController.customize()
    }
    
    /**
     *  private function to set up the tableview for displaying the movie search results
     */
    private func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = CGFloat(Constants.movieSearchListTableViewEstimatedRowHeight)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = UIView(frame:.zero)
        self.tableView.backgroundColor = .clear
    }
    
    
    /**
     * function that updates the various ui elements on the screen based on viewController's state
     * parameters - enum indicating the viewControllerState
     * returns - nothing
     */
    private func updateUI(for state:movieSearchListViewControllerStates) {
        switch state {
        case .searchNotStarted:
            tableView.isHidden = true
            movieListViewControllerSpinner.isHidden = true
            movieListViewControllerSpinner.stopAnimating()
            informatoryLabel.isHidden = false
            
        case .searchBegan:
            self.view.bringSubviewToFront(movieListViewControllerSpinner)
            tableView.isHidden = true
            informatoryLabel.isHidden = true
            movieListViewControllerSpinner.isHidden = false
            movieListViewControllerSpinner.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        case .searchEndedWithResults:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            movieListViewControllerSpinner.stopAnimating()
            tableView.isHidden = false
            self.view.bringSubviewToFront(tableView)
            informatoryLabel.isHidden = true
            
        case .searchFailedWithoutResults:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            movieListViewControllerSpinner.stopAnimating()
            tableView.isHidden = true
            informatoryLabel.isHidden = false
            
        }
    }

}

// MARK: extension MovieSearchListViewModelDelegate

/**
 * Implementing the MovieSearchListViewModelDelegate to handle the success and failure of search results
 */
extension MovieSearchListViewController: MovieSearchListViewModelDelegate {
    
    /**
     * function to handle success case of the fetch completion
     * parameters - new index paths to reload
     * returns - nothing
     */
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        self.updateUI(for: .searchEndedWithResults)
        
        guard let newIndexPathsToReload = newIndexPathsToReload, let firstNewIndexPath = newIndexPathsToReload.first else {
            tableView.reloadData()
            return
        }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: newIndexPathsToReload, with:.fade)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRow(at: firstNewIndexPath, at: .top, animated:true)
    }
    
    /**
     * function to handle the failure case of fetch completion
     * parameters - string indicating the reason for failure
     * returns - nothing
     */
    func onFetchFailed(with reason: String) {
        
        self.updateUI(for: .searchFailedWithoutResults)
        let title = Constants.failedToLoadMoviesMessage.localizedCapitalized
        let action = UIAlertAction(title: Constants.OkButtonTitle.localizedUppercase, style: .default)
        self.displayAlert(with: title , message: reason, actions: [action])
    }
  
}

// MARK: extension MovieSearchListViewController to compute if current cell is a loading cell

private extension MovieSearchListViewController {

    /**
     * function to determine if the loading cell needs to appear
     * parameters - current indexPath for the cell to be rendered
     * returns - Bool indicating if the loading cell needs to be displayed.
     */
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        
        if let viewModel = viewModel{
            return indexPath.row >= (viewModel.currentCount)
        }
        return false
    }
}

// MARK: extenstion UIScrollViewDelegate

/**
 * extension to implement UIScrollViewDelegate
 */
extension MovieSearchListViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /**
         * Need to determine if user has scrolled to the bottom of the table,
         * if yes, we check if we can fetch the additional pages from server.
         * This will implement the infinite scrolling behaviour for the tableview pagination.
         */
        if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height))
        {
            Logger.logInfo("Can begin fetching movies if max page limit is not reached")
            viewModel?.fetchMovies()
        }
    }
}

// MARK: extenstion UITableViewDataSource

/**
 * extension to implement UITableViewDataSource
 */
extension MovieSearchListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiers.listCellIdentifier,
                                                    for: indexPath) as? movieSearchListTableViewCell {
            
            if isLoadingCell(for: indexPath) {
                cell.configure(at: indexPath.row, viewModel:.none)
            } else {
                cell.configure(at: indexPath.row, viewModel: viewModel)
            }
            
            cell.selectionStyle = .none
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
}


// MARK: extenstion UISearchBarDelegate

/**
 * extension to implement UISearchBarDelegate
 */
extension MovieSearchListViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar == searchController.searchBar {
            searchBar.placeholder = Constants.searchControllerPlaceholder.localizedCapitalized
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == searchController.searchBar {
            searchText = searchBar.text
            searchController.isActive = false
        }
    }
    
}
