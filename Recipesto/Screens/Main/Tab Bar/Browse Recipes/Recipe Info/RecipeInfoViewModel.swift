//
//  RecipeInfoViewModel.swift
//  Recipesto
//
//  Created by Max Park on 3/24/23.
//

import Foundation
import Combine

class RecipeInfoViewModel {
    
    enum Input {
        case viewDidAppear
        case tappedCell(recipe: Item)
        case search(text: String)
    }
    
    enum Output {
        case fetchRecipesDidFail(error: Error)
        case fetchBrowseRecipesDidSucceed(results: [Result])
        case fetchSearchRecipesDidSucceed(results: [Item])
    }
    
    weak var coordinator: BrowseCoordinator!
    
    let output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
    init() {}
}
