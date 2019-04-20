//
//  MovieSearchListViewController.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class MovieSearchListViewController: UIViewController, UITableViewDelegate {
  
    
    @IBOutlet weak var tableView: UITableView!
    var searchController:  UISearchController!
    @IBOutlet weak var movieListViewControllerSpinner: UIActivityIndicatorView!
    
    private enum identifiers {
        static let listCellIdentifier = "customCell"
    }
    
    private enum movieSearchListViewControllerStates:Int {
        case searchNotStarted
        case searchBegan
        case searchEndedWithResults
        case searchFailedWithoutResults
    }
    
    private var viewModel: MovieSearchListViewModel?
    
    fileprivate var searchText: String? {
        didSet {
            guard let queryText = searchText else { return }
                
            if !queryText.isEmpty{
                searchController?.searchBar.text = queryText
                searchController?.searchBar.placeholder = queryText
                
                self.updateUI(for: .searchBegan)
                let request = MovieSearchRequest.from(searchText:queryText)
                
                viewModel = MovieSearchListViewModel(dataManager: MovieSearchListDataManager(), delegate: self, request: request)
                viewModel?.fetchMovies()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpUI()

    }
    
    private func setUpUI(){
        self.navigationItem.title = "Movies".localizedUppercase
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = CGFloat(Constants.movieSearchListTableViewEstimatedRowHeight)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = UIView(frame:.zero)
        self.tableView.backgroundColor = .clear
        self.view.backgroundColor = Constants.backgroundColor
        self.movieListViewControllerSpinner.stopAnimating()
        self.setupSearchController()
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Movies".localizedCapitalized
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    convenience init(viewModel: MovieSearchListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    /**
     * function that updates the various ui elements on the screen based on its state
     */
    private func updateUI(for state:movieSearchListViewControllerStates){
        switch state {
        case .searchNotStarted:
            tableView.isHidden = true
            movieListViewControllerSpinner.isHidden = true
            movieListViewControllerSpinner.stopAnimating()
//            informatoryLabel.isHidden = false
            
        case .searchBegan:
        self.view.bringSubviewToFront(movieListViewControllerSpinner)
            tableView.isHidden = true
//            informatoryLabel.isHidden = true
            movieListViewControllerSpinner.isHidden = false
            movieListViewControllerSpinner.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        case .searchEndedWithResults:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            movieListViewControllerSpinner.stopAnimating()
            tableView.isHidden = false
            self.view.bringSubviewToFront(tableView)
//            informatoryLabel.isHidden = true
            
        case .searchFailedWithoutResults:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            movieListViewControllerSpinner.stopAnimating()
            tableView.isHidden = true
//            informatoryLabel.isHidden = false
            
        }
    }

}


extension MovieSearchListViewController: MovieSearchListViewModelDelegate {
    
    //  on success case of the fetch completion
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
    
    // on the failure case of fetch completion
    func onFetchFailed(with reason: String) {
        
        self.updateUI(for: .searchFailedWithoutResults)
        let title = "Failed to load the movies".localizedCapitalized
        let action = UIAlertAction(title: "OK".localizedUppercase, style: .default)
        self.displayAlert(with: title , message: reason, actions: [action])
    }
  
}

private extension MovieSearchListViewController {
    // determine if the loading cell needs to appear
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        
        if let viewModel = viewModel{
            return indexPath.row >= (viewModel.currentCount)
        }
        return false
    }
}

/**
 * scroll view delegate
 */
extension MovieSearchListViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /**
         * Need to determine if user has scrolled to the bottom of the table, if yes, we fetch the additional pages from server
         * this will implement the infinite scrolling behaviour for the tableview pagination.
         */
        if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height))
        {
            Logger.logInfo("Can begin fetching movies if max page limit is not reached")
            viewModel?.fetchMovies()
        }
    }
}

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


extension MovieSearchListViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar == searchController.searchBar {
            searchBar.placeholder = "Search Movies"
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
