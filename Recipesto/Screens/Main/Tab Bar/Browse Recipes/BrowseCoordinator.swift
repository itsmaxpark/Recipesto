//
//  BrowseCoordinator.swift
//  The Coordinator for the BrowseVC

import UIKit

class BrowseCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = .init()
    
    init() {
        rootViewController = UINavigationController()
    }
    
    /// Creates the BrowseVC and injects a BrowseViewModel
    func start() {
        let viewModel = BrowseViewModel()
        viewModel.coordinator = self
        
        let browseVC = BrowseVC(viewModel: viewModel)
        browseVC.title = "Browse"
        
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.setViewControllers([browseVC], animated: true)
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
