//
//  MovieSearchListViewController.swift
//  MovieSearch
//
//  Created by Dharamshi, Lopa D on 4/20/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class MovieSearchListViewController: UIViewController {
  
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieListViewControllerSpinner: UIActivityIndicatorView!
    
    private enum identifiers {
        static let listCellIdentifier = "movie search list cell"
    }
    
    private enum movieSearchListViewControllerStates:Int {
        case searchNotStarted
        case searchBegan
        case searchEndedWithResults
        case searchFailedWithoutResults
    }
    
    private var viewModel: MovieSearchListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.setUpUI()
        
        self.updateUI(for: .searchBegan)
        let request = MovieSearchRequest.from(searchText:"Harry Potter")
        
        viewModel = MovieSearchListViewModel(dataManager: MovieSearchListDataManager(), delegate: self, request: request)
        viewModel?.fetchMovies()
    }
    
    private func setUpUI(){
        self.navigationItem.title = viewModel?.screenTitle
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = CGFloat(Constants.movieSearchListTableViewEstimatedRowHeight)
        self.tableView.rowHeight = UITableView.automaticDimension

//        let movieSearchListCell = UINib(nibName: identifiers.listCellIdentifier, bundle: nil)
        self.tableView.register(MovieSearchListTableViewCell.self, forCellReuseIdentifier:identifiers.listCellIdentifier)
        
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

extension MovieSearchListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifiers.listCellIdentifier,
                                                    for: indexPath) as? MovieSearchListTableViewCell {
            
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
    
    private func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame:.zero)
    }
    
    
}

