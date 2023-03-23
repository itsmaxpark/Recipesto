//
//  RPTabBarController.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class RPTabBarController: NiblessTabBarController {
    
    let browseVC: BrowseVC
    let swipeVC: SwipeVC
    let favoritesVC: FavoritesVC
    
    init(browseVC: BrowseVC, swipeVC: SwipeVC, favoritesVC: FavoritesVC) {
        self.browseVC = browseVC
        self.swipeVC = swipeVC
        self.favoritesVC = favoritesVC
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createBrowseNC() ,createSwipeNC(), createFavoritesNC()]
    }
    
    func createBrowseNC() -> UINavigationController {
        browseVC.title = "Browse"
        browseVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        
        return UINavigationController(rootViewController: browseVC)
    }
    
    func createSwipeNC() -> UINavigationController {
        swipeVC.title = "Search"
        swipeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        return UINavigationController(rootViewController: swipeVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        return UINavigationController(rootViewController: favoritesVC)
    }
}
