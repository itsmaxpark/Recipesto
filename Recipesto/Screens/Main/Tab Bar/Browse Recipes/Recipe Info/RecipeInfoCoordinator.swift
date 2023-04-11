//
//  RecipeInfoCoordinator.swift
//  Recipesto
//
//  Created by Max Park on 3/26/23.
//

import Foundation

import UIKit

class RecipeInfoCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    init() {
        rootViewController = UINavigationController()
    }
    
    func start() {
        let viewModel = RecipeInfoViewModel()
        viewModel.coordinator = self
        
        let recipeInfoVC = RecipeInfoVC(viewModel: viewModel)
        
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.setViewControllers([recipeInfoVC], animated: true)
    }
    
}
