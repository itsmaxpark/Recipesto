//
//  BrowseVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class BrowseVC: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: BrowseViewModel
    var rootView: BrowseRootView {
        view as! BrowseRootView
    }

    // MARK: - Methods
    init(viewModel: BrowseViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        configureSearchController()
    }

    override func loadView() {
        super.loadView()
        view = BrowseRootView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: ScreenSize.width,
                height: ScreenSize.height),
            viewModel: viewModel
        )
    }
    
    private func configureVC() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureCollectionView() {
        rootView.collectionView.delegate = self
    }
    
    private func configureSearchController() {
        rootView.suggestedSearchController = SuggestedSearchController()
        rootView.searchController = RPSearchController(searchResultsController: nil)
        rootView.searchController.searchResultsUpdater = self
        rootView.searchController.delegate = self
        rootView.searchController.obscuresBackgroundDuringPresentation = false
        
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

// MARK: - Search Results Updating Delegate
extension BrowseVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Make sure there is text in the search bar
        guard rootView.isSearchBarEmpty == false else {
            rootView.input.send(.viewDidAppear)
            return
        }
        // When user types text, format text to lowercase
        let text = searchController.searchBar.text!.lowercased()
        // Cancel search requests that have not yet finished to reduce API usage
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // Use text as searchText in getSearchedRecipe()
        rootView.searchText = text
    }
}

// MARK: - Collection View Delegate
extension BrowseVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sectionRecipes: [Item]
        // Check whether to use featured result or search result recipes
        if rootView.isFiltering {
            guard let recipes = rootView.filteredSections[indexPath.section].items else { return }
            sectionRecipes = recipes
        } else {
            guard let recipes = rootView.featuredSections[indexPath.section].items else { return }
            sectionRecipes = recipes
        }
        
        let recipe = sectionRecipes[indexPath.item]
        let recipes = recipe.recipes
        if let recipes = recipes, recipes.count > 1 {
            let destVC = MultipleRecipeInfoVC()
            destVC.set(item: recipe)
            navigationController?.pushViewController(destVC, animated: true)
        } else {
            rootView.input.send(.tappedCell(recipe: recipe))
        }
    }
}
