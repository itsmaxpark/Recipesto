//
//  FavoritesCoordinator.swift
//  Recipesto
//
//  Created by Max Park on 3/23/23.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = .init()
    
    init() {
        rootViewController = UINavigationController()
    }
    
    func start() {
        let viewModel = FavoritesViewModel()
        viewModel.coordinator = self
        
        let favoritesVC = FavoritesVC(viewModel: viewModel)
        favoritesVC.title = "Favorites"
        
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.setViewControllers([favoritesVC], animated: true)
    }
    
    /// Navigates to the RecipeInfoVC with an injected Recipe to be displayed
    func goToRecipeInfoVC(with recipe: Item) {
        let viewModel = RecipeInfoViewModel()
        viewModel.coordinator = RecipeInfoCoordinator()
        
        let recipeInfoVC = RecipeInfoVC(viewModel: viewModel)
        recipeInfoVC.rootView.set(recipe: recipe)
        rootViewController.pushViewController(recipeInfoVC, animated: true)
    }
    
}
