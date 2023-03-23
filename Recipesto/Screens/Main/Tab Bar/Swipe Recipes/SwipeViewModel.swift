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
    }
    
    enum Output {
        case fetchRecipeDidFail(error: Error)
        case fetchRecipeDidSucceed(recipe: Item)
        case toggleButtons(isEnabled: Bool)
    }
    
    let output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
    let session = MockNetworkManager.shared

    init() {}
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {
            case .viewDidAppear, .didSwipeAction:
                self.handleGetRecipe()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func handleGetRecipe() {
        output.send(.toggleButtons(isEnabled: false))
        session.getRandomRecipe().sink { [weak self] completion in
          self?.output.send(.toggleButtons(isEnabled: true))
          if case .failure(let error) = completion {
              self?.output.send(.fetchRecipeDidFail(error: error))
          }
        } receiveValue: { [weak self] recipes in
//            print(recipes)
            guard let recipe = recipes.results.randomElement() else {
                self?.output.send(.fetchRecipeDidFail(error: RPError.invalidData))
                return 
            }
            self?.output.send(.fetchRecipeDidSucceed(recipe: recipe))
        }.store(in: &cancellables)
    }
    
}
