//
//  PersistenceManager.swift
//  Github Followers 2
//
//  Created by Max Park on 11/14/22.
//

import UIKit
import Combine

enum PersistenceActionType { case add, remove }
enum PersistenceResultType { case success, failure, alreadyExists }

class PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys { static let favorites = "favorites" }
    let cancellables = Set<AnyCancellable>()
    
    static func updateWith(favorite: Item, actionType: PersistenceActionType) -> AnyPublisher<PersistenceResultType, RPError> {
        retrieveFavorites()
            .map { favorites -> PersistenceResultType in
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        return .alreadyExists
                    }
                    var newFavorites = favorites
                    newFavorites.append(favorite)
                    return save(favorites: newFavorites)
                case .remove:
                    var newFavorites = favorites
                    newFavorites.removeAll { $0.name == favorite.name }
                    return save(favorites: newFavorites)
                }
            }
            .eraseToAnyPublisher()
    }
    
    static func retrieveFavorites() -> AnyPublisher<[Item], RPError> {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return Just([])
                .setFailureType(to: RPError.self)
                .eraseToAnyPublisher()
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Item].self, from: favoritesData)
            return Just(favorites)
                .setFailureType(to: RPError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: .unableToFavorite)
                .eraseToAnyPublisher()
        }
    }
    
    static func save(favorites: [Item]) -> PersistenceResultType {
        let encoder = JSONEncoder()
        do {
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return .success
        } catch {
            return .failure
        }
    }
}
