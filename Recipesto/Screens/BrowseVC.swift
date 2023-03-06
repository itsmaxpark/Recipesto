//
//  BrowseVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class BrowseVC: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Result, Item>?
    var sections: [Result]!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCV()
        getRecipes()
        configureDataSource()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    func getRecipes() {
        Task {
            do {
                let featuredResponse: [String: [Result]] = try await NetworkManager.shared.getFeaturedRecipes(page: 0, isVegetarian: false)
                guard let featuredResults = featuredResponse["results"] else { return }
                var sections: [Result] = []
                for result in featuredResults { if result.minItems == 8 { sections.append(result) } }
                self.sections = sections
                reloadData()
            } catch {
                if let rpError = error as? RPError {
                    presentRPAlert(title: "Uh oh", message: rpError.rawValue, buttonTitle: "Ok") } else { presentDefaultAlert() }
            }
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]

            switch section.type {
            default:
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
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RPSectionHeader.reuseIdentifier, for: indexPath) as? RPSectionHeader else { return UICollectionReusableView() }

            guard let firstRecipe = self?.dataSource?.itemIdentifier(for: indexPath) else { return UICollectionReusableView() }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstRecipe) else { return UICollectionReusableView() }
            if section.name == nil { return UICollectionReusableView() }

            sectionHeader.title.text = section.name
            return sectionHeader
        }
    }
    
    // A featured section displaying only one recipe with no scrolling
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
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Result, Item>()
        snapshot.appendSections(sections)
        for section in sections { if let items: [Item] = section.items { snapshot.appendItems(items, toSection: section) } }
        dataSource?.apply(snapshot)
    }
}

extension BrowseVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionRecipes = sections[indexPath.section].items else { return }
        let recipe = sectionRecipes[indexPath.item]
        
        let destVC = RecipeInfoVC()
        destVC.set(recipe: recipe)
        navigationController?.pushViewController(destVC, animated: true)
    }
}


