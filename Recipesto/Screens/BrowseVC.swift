//
//  BrowseVC.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class BrowseVC: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Result, Recipe>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.identifier)
    }
    
    func getRecipes() {
        Task {
            do {
                let featuredResponse: [String: [Result]] = try await NetworkManager.shared.getFeaturedRecipes(page: 0, isVegetarian: false)
                guard let featuredResults = featuredResponse["results"] else { return }
                for result in featuredResults { print(result.name ?? "No name") }
                
            } catch {
                if let rpError = error as? RPError { presentRPAlert(title: "Uh oh", message: rpError.rawValue, buttonTitle: "Ok")
                } else { presentDefaultAlert() }
            }
        }
    }
}

extension BrowseVC: UICollectionViewDelegate {
    
}


