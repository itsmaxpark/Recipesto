//
//  BrowseRootView.swift
//  Recipesto
//
//  Created by Max Park on 3/23/23.
//

import UIKit
import Combine

class BrowseRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: BrowseViewModel
    let input: PassthroughSubject<BrowseViewModel.Input, Never> = .init()
    @Published var searchText: String?
    var cancellables = Set<AnyCancellable>()
    
    lazy var collectionView = UICollectionView()
    lazy var suggestedSearchController = SuggestedSearchController()
    lazy var searchController = UISearchController()
    
    var dataSource: UICollectionViewDiffableDataSource<Result, Item>?
    var featuredSections: [Result] = []
    var filteredSections: [Result] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - Methods
    init(frame: CGRect, viewModel: BrowseViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        configureCV()
        configureDataSource()
        bind()
        input.send(.viewDidAppear)
    }
    
    func bind() {
        $searchText
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.input.send(.search(text: query))
            }.store(in: &cancellables)
        
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case .fetchBrowseRecipesDidSucceed(let results):
                self?.featuredSections = results
                self?.reloadData()
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.collectionViewLayout = RPCompositionalLayout.createBrowseCompositionalLayout()
            case .fetchSearchRecipesDidSucceed(let results):
                self?.filteredSections = [Result(type: "search", name: "Results", category: nil, minItems: nil, items: results, item: nil)]
                self?.reloadData()
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.collectionViewLayout = RPCompositionalLayout.createSearchCompositionalLayout()
                self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            case .fetchRecipesDidFail(let error):
                print("Error fetching browse recipes: \(error)")
            }
//            self?.reloadData()
        }.store(in: &cancellables)
    }
    
    func configureCV() {
        collectionView = UICollectionView(
            frame: self.bounds,
            collectionViewLayout: RPCompositionalLayout.createBrowseCompositionalLayout())
        addSubview(collectionView)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.contentInset = adjustForTabbarInsets
        collectionView.scrollIndicatorInsets = adjustForTabbarInsets
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
        collectionView.register(RPSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RPSectionHeader.reuseIdentifier)
    }
    
    func configureDataSource() {
        // Configure the cell based on the recipe
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, recipe in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
            cell.set(recipe: recipe)
            return cell
        })
        
        // Use RPSectionHeader as supplementary view for collectionView and set title
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RPSectionHeader.reuseIdentifier, for: indexPath) as? RPSectionHeader
            else { fatalError() }
            guard let firstRecipe = self?.dataSource?.itemIdentifier(for: indexPath) else { return UICollectionReusableView() }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstRecipe) else { return UICollectionReusableView() }
            if section.name == nil { return UICollectionReusableView() }

            sectionHeader.title.text = section.name
            return sectionHeader
        }
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
                snapshot.appendItems(items, toSection: section)
            }
        }
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}



