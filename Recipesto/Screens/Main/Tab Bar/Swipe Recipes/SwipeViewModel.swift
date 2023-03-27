//
//  SwipeViewModel.swift
//  Recipesto
//
//  Created by Max Park on 3/22/23.
//

import Foundation
import Combine

class SwipeViewModel {
    
    enum Input {
        case viewDidAppear
        case didSwipeAction
        case didFavorite(recipe: Item)
    }
    
    enum Output {
        case fetchRecipeDidFail(error: Error)
        case fetchRecipeDidSucceed(recipe: Item)
        case toggleButtons(isEnabled: Bool)
    }
    
    weak var coordinator: SwipeCoordinator?
    let output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
    let session = MockNetworkManager.shared

    init() {}
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {
            case .viewDidAppear, .didSwipeAction:
                self.handleGetRecipe()
            case .didFavorite(let recipe):
                self.handleSaveToFavorite(recipe: recipe)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func handleSaveToFavorite(recipe: Item) {
        //        PersistenceManager.updateWith(favorite: recipe, actionType: .add)
    }
    func handleGetRecipe() {
        output.send(.toggleButtons(isEnabled: false))
        session.getSwipeRecipe().sink { [weak self] completion in
          self?.output.send(.toggleButtons(isEnabled: true))
          if case .failure(let error) = completion {
              self?.output.send(.fetchRecipeDidFail(error: error))
          }
        } receiveValue: { [weak self] recipes in
            guard let recipe = recipes.results.randomElement() else {
                self?.output.send(.fetchRecipeDidFail(error: RPError.invalidData))
                return 
            }
            self?.output.send(.fetchRecipeDidSucceed(recipe: recipe))
        }.store(in: &cancellables)
    }
    
}
