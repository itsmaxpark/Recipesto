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
        configureViewController()
        configureCollectionView()
        getRecipes()
        configureDataSource()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
    }
    
    func getRecipes() {
        Task {
            do {
                let featuredResponse: [String: [Result]] = try await NetworkManager.shared.getFeaturedRecipes(page: 0, isVegetarian: false)
                guard let featuredResults = featuredResponse["results"] else {
                    print("results fetch failed")
                    return
                }
//                self.sections = featuredResults
                var sections: [Result] = []
                for result in featuredResults {
                    if result.minItems == 8 {
                        sections.append(result)
                        print(result.name ?? "No name")
                    }
                }
                self.sections = sections
                reloadData()
                
            } catch {
                if let rpError = error as? RPError {
                    presentRPAlert(title: "Uh oh", message: rpError.rawValue, buttonTitle: "Ok")
                    print("getRecipes: error")
                }
                else {
                    presentDefaultAlert()
                }
            }
        }
    }
    
    func createBrowseFlowLayout() -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout()
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
        layout.configuration = config
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, recipe in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
            cell.set(recipe: recipe)
            return cell
        })
    }
    
    // A featured section displaying only one recipe with no scrolling
    func createFeaturedSection(using section: Result) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .none
        return layoutSection
    }
    
    func reloadData() {
        print("Reload data")
        var snapshot = NSDiffableDataSourceSnapshot<Result, Item>()
        snapshot.appendSections(sections)
        for section in sections {
//            print(section)
            if let items: [Item] = section.items {
                snapshot.appendItems(items, toSection: section)
            }
        }

        dataSource?.apply(snapshot)
    }
}

extension BrowseVC: UICollectionViewDelegate {
    
}


