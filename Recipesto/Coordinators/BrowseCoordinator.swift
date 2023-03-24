//
//  BrowseCoordinator.swift
//  Recipesto
//
//  Created by Max Park on 3/23/23.
//

import UIKit

class BrowseCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    init() {
        rootViewController = UINavigationController()
    }
    
    func start() {
        let viewModel = BrowseViewModel()
        viewModel.coordinator = self
        
        let browseVC = BrowseVC(viewModel: viewModel)
        browseVC.title = "Browse"
        
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.setViewControllers([browseVC], animated: true)
    }
    
    func goToRecipeInfoVC(with recipe: Item) {
        let viewModel = RecipeInfoViewModel()
        viewModel.coordinator = self
        
        let recipeInfoVC = RecipeInfoVC(viewModel: viewModel)
        recipeInfoVC.rootView.set(recipe: recipe)
        rootViewController.pushViewController(recipeInfoVC, animated: true)
    }
}
