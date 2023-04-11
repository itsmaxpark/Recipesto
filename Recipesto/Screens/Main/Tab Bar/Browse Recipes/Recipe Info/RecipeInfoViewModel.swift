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
        case didTapSave(recipe: Item)
    }
    
    enum Output {
        case alreadySaved
        case saveActionDidFail(error: RPError)
        case success
    }
    
    weak var coordinator: RecipeInfoCoordinator!
    
    let output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    /// Takes an event input and sends the appropriate output event
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {
            case .viewDidAppear:
                break
            case .didTapSave(let recipe):
                self.handleDidTapSave(recipe: recipe)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func handleDidTapSave(recipe: Item) {
        PersistenceManager.updateWith(favorite: recipe, actionType: .add).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.output.send(.saveActionDidFail(error: error))
            }
        } receiveValue: { [weak self] event in
            switch event {
            case .failure:
                print("handleDidTapSave: failure")
                self?.output.send(.saveActionDidFail(error: .unableToFavorite))
            case .alreadyExists:
                print("handleDidTapSave: alreadyExists")
                self?.output.send(.alreadySaved)
            case .success:
                print("handleDidTapSave: success")
            }
        }.store(in: &cancellables)

    }
}
