//
//  TabBarCoordinator.swift
//  Recipesto
//
//  Created by Max Park on 3/23/23.
//

import UIKit

class TabBarCoordinator: Coordinator {
    
    let rootViewController: UITabBarController
    
    var childCoordinators = [Coordinator]()
    
    init() {
        self.rootViewController = UITabBarController()
    }
    
    func start() {
        let browseCoordinator = BrowseCoordinator()
        browseCoordinator.start()
        self.childCoordinators.append(browseCoordinator)
        let browseVC = browseCoordinator.rootViewController
        browseVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        
        let swipeCoordinator = SwipeCoordinator()
        swipeCoordinator.start()
        self.childCoordinators.append(swipeCoordinator)
        let swipeVC = swipeCoordinator.rootViewController
        swipeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let favoritesCoordinator = FavoritesCoordinator()
        favoritesCoordinator.start()
        self.childCoordinators.append(favoritesCoordinator)
        let favoritesVC = favoritesCoordinator.rootViewController
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        self.rootViewController.viewControllers = [
            browseVC,
            swipeVC,
            favoritesVC
        ]
    }
    
   
}
