//
//  FavoritesCoordinator.swift
//  Recipesto
//
//  Created by Max Park on 3/23/23.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    lazy var favoritesVC = FavoritesVC()
    
    init() {
        self.rootViewController = UINavigationController()
        self.rootViewController.title = "Favorites"
    }
    
    func start() {
        rootViewController.setViewControllers([favoritesVC], animated: true)
    }
}
