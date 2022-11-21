//
//  RPTabBarController.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class RPTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createBrowseNC() ,createSearchNC(), createFavoritesNC()]
    }
    
    func createBrowseNC() -> UINavigationController {
        let browseVC = BrowseVC()
        browseVC.title = "Browse"
        browseVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        
        return UINavigationController(rootViewController: browseVC)
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesVC()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        return UINavigationController(rootViewController: favoritesVC)
    }
}
