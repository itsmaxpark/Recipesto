//
//  RPSearchController.swift
//  Recipesto
//
//  Created by Max Park on 3/10/23.
//

import UIKit

class RPSearchController: UISearchController {
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        searchBar.placeholder = "Search for a recipe"
        obscuresBackgroundDuringPresentation = false
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .done
        
    }
}
