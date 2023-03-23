//
//  BrowseVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class BrowseVC: NiblessViewController {
    
    let viewModel: BrowseViewModel

    var rootView: BrowseRootView {
        view as! BrowseRootView
    }
   
    
    init(viewModel: BrowseViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureNavBar()
        configureSearchController()
    }
    
    override func loadView() {
        view = BrowseRootView(viewModel: viewModel)
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func configureSearchController() {
        rootView.suggestedSearchController = SuggestedSearchController()
        rootView.searchController = RPSearchController(searchResultsController: nil)
        rootView.searchController.searchResultsUpdater = self
        rootView.searchController.delegate = self
        rootView.searchController.searchBar.delegate = self
        
        navigationItem.searchController = rootView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
}

// MARK: - Search Controller Delegate
extension BrowseVC: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        
    }
    
}

// MARK: - Search Bar Delegate
extension BrowseVC: UISearchBarDelegate {
    
    /// Tells the delegate that the search bar cancel button was tapped
    /// Show featured receipes on button tap instead of search results
    /// - Parameter searchBar: search bar of search controller
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        getFeaturedRecipes()
//        configureDataSource()
//        reloadData()
    }
}

// MARK: - Search Results Updating Delegate
extension BrowseVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Make sure there is text in the search bar
//        guard isSearchBarEmpty == false else { return }
        // When user types text, format text to lowercase
//        let text = searchController.searchBar.text!.lowercased()
        // Cancel search requests that have not yet finished to reduce API usage
//        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // Use text as searchText in getSearchedRecipe()
//        perform(#selector(getSearchedRecipes(searchText:)), with: text, afterDelay: TimeInterval(1.0))
        
    }
    
}

