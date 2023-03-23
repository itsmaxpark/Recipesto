//
//  BrowseViewModel.swift
//  Recipesto
//
//  Created by Max Park on 3/22/23.
//

import Foundation
import Combine

class BrowseViewModel {
    
    enum Input {
        case viewDidAppear
    }
    
    enum Output {
        case fetchRecipesDidFail(error: Error)
        case fetchBrowseRecipesDidSucceed(results: [Result])
        case fetchSearchRecipesDidSucceed(results: [Item])
    }
    
    let output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
    let session = MockNetworkManager.shared
    
    init() {}
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {
            case .viewDidAppear:
                self.handleGetFeaturedRecipes()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func handleGetFeaturedRecipes() {
        session.getFeaturedRecipes().sink { [weak self] completion in
          if case .failure(let error) = completion {
              self?.output.send(.fetchRecipesDidFail(error: error))
          }
        } receiveValue: { [weak self] featuredResponse in
            guard let featuredResults = featuredResponse["results"] else {
                self?.output.send(.fetchRecipesDidFail(error: RPError.invalidData))
                return
            }
            var sections: [Result] = []
            for result in featuredResults { if result.minItems == 8 { sections.append(result) } }
            self?.output.send(.fetchBrowseRecipesDidSucceed(results: sections))
        }.store(in: &cancellables)
    }
    
    func handleGetSearchRecipes() {
        session.getRandomRecipe().sink { [weak self] completion in
          if case .failure(let error) = completion {
              self?.output.send(.fetchRecipesDidFail(error: error))
          }
        } receiveValue: { [weak self] recipes in
            let recipes: [Item] = recipes.results
            self?.output.send(.fetchSearchRecipesDidSucceed(results: recipes))
        }.store(in: &cancellables)
    }
}
