//
//  BrowseVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class BrowseVC: UIViewController {
    
    var collectionView: UICollectionView!
    var suggestedSearchController: SuggestedSearchController!
    var searchController: UISearchController!
    var dataSource: UICollectionViewDiffableDataSource<Result, Item>?
    var featuredSections: [Result] = []
    var filteredSections: [Result] = []
    var filteredRecipes: [Item] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCV()
        configureNavBar()
        configureSearchController()
        getFeaturedRecipes()
        configureDataSource()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCV() {
        collectionView = UICollectionView(frame: view.safeAreaLayoutGuide.layoutFrame, collectionViewLayout: createCompositionalLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.contentInset = adjustForTabbarInsets
        collectionView.scrollIndicatorInsets = adjustForTabbarInsets
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        collectionView.register(RPSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RPSectionHeader.reuseIdentifier)
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func configureSearchController() {
        suggestedSearchController = SuggestedSearchController()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a recipe"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.returnKeyType = .done
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    func getFeaturedRecipes() {
        Task {
            do {
                let featuredResponse: [String: [Result]] = try await NetworkManager.shared.getFeaturedRecipes(page: 0, isVegetarian: false)
                guard let featuredResults = featuredResponse["results"] else { return }
                var sections: [Result] = []
                for result in featuredResults { if result.minItems == 8 { sections.append(result) } }
                featuredSections = sections
                reloadData()
            } catch {
                if let rpError = error as? RPError {
                    presentRPAlert(title: "Uh oh", message: rpError.rawValue, buttonTitle: "Ok") } else { presentDefaultAlert() }
            }
        }
    }
    
    /// Receives a filtered list of recipes using the searchText
    /// - Parameter searchText: String to filter recipes by
    @objc func getSearchedRecipes(searchText: String) {

        Task {
            let recipesResult: RecipeResult
            
            do {
                recipesResult = try await NetworkManager.shared.getSearchRecipe(page: 0, isVegetarian: false, tags: "", searchText: searchText)
                filteredRecipes = recipesResult.results
                filteredSections = [Result(type: "search", name: "Results", category: nil, minItems: nil, items: filteredRecipes, item: nil)]
                reloadData()
            } catch {
                if let rpError = error as? RPError {
                    presentRPAlert(title: "Uh oh", message: rpError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultAlert()
                }
            }
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { fatalError() }
            
            let section: Result
            if self.isFiltering {
                section = self.filteredSections[sectionIndex]
                return self.createFilteredSection(using: section)
            } else {
                section = self.featuredSections[sectionIndex]
                return self.createFeaturedSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        config.scrollDirection = .vertical
        layout.configuration = config
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, recipe in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
            cell.set(recipe: recipe)
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            print(indexPath)
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RPSectionHeader.reuseIdentifier, for: indexPath) as? RPSectionHeader
            else { fatalError() }
            guard let firstRecipe = self?.dataSource?.itemIdentifier(for: indexPath) else { return UICollectionReusableView() }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstRecipe) else { return UICollectionReusableView() }
            if section.name == nil { return UICollectionReusableView() }

            sectionHeader.title.text = section.name
            return sectionHeader
        }
    }
    
    // A featured section displaying multiple recipes in horizonal carosels
    func createFeaturedSection(using section: Result) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(0.2))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createFilteredSection(using section: Result) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.28))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, repeatingSubitem: layoutItem, count: 2)

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.orthogonalScrollingBehavior = .none
        
//        let layoutSectionHeader = createSectionHeader()
//        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    
    /// Reload and apply the diffable data source
    /// Uses featured recipes on the BrowseVC
    /// Uses filtered recipes when using the search controller
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Result, Item>()
        let snapshotSection: [Result]
        
        if isFiltering {
            snapshotSection = filteredSections
            snapshot.appendSections(snapshotSection)
        } else {
            snapshotSection = featuredSections
            snapshot.appendSections(snapshotSection)
        }
        for section in snapshotSection {
            if let items: [Item] = section.items {
//                for item in items {
//                    if item.recipes != nil {
//                        items
//                    }
//                }
                snapshot.appendItems(items, toSection: section)
            }
        }
        dataSource?.apply(snapshot)
    }
}

// MARK: - Collection View Delegate
extension BrowseVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionRecipes: [Item]
        
        // Check whether to use featured result or search result recipes
        if isFiltering {
            guard let recipes = filteredSections[indexPath.section].items else { return }
            sectionRecipes = recipes
        } else {
            guard let recipes = featuredSections[indexPath.section].items else { return }
            sectionRecipes = recipes
        }
        let recipe = sectionRecipes[indexPath.item]
        
        let destVC = RecipeInfoVC()
        destVC.set(recipe: recipe)
        navigationController?.pushViewController(destVC, animated: true)
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
    
}

// MARK: - Search Results Updating Delegate
extension BrowseVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Make sure there is text in the search bar
        guard isSearchBarEmpty == false else { return }
        // When user types text, format text to lowercase
        let text = searchController.searchBar.text!.lowercased()
        // Cancel search requests that have not yet finished to reduce API usage
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // Use text as searchText in getSearchedRecipe()
        perform(#selector(getSearchedRecipes(searchText:)), with: text, afterDelay: TimeInterval(1.0))
        
    }
    
}

