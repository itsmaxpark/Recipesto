//
//  MockNetworkManager.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit
import Combine

class MockNetworkManager {
    
    static let shared = MockNetworkManager()
    
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    let size: String = "5"
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        self.session = session
    }
    
    func getBrowseRecipes(page: Int = 0, isVegetarian: Bool = false)
        -> AnyPublisher<[String: [Result]], Error> {
        
        if let url = Bundle.main.url(forResource: "MockBrowseData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let recipes = try decoder.decode([String: [Result]].self, from: data)
                return Just(recipes)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                print("error:\(error)")
            }
        }
        return Fail(error: "Error" as! Error).eraseToAnyPublisher()
    }
    
    func getSearchRecipe() -> AnyPublisher<RecipeResult, Error> {
        // get only chicken data
        if let url = Bundle.main.url(forResource: "MockSearchData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let recipes = try decoder.decode(RecipeResult.self, from: data)
                return Just(recipes)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                print("error:\(error)")
            }
        }
        return Fail(error: "Error" as! Error).eraseToAnyPublisher()
    }

    func getSwipeRecipe() -> AnyPublisher<RecipeResult, Error> {
        
        if let url = Bundle.main.url(forResource: "MockSwipeData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let recipes = try decoder.decode(RecipeResult.self, from: data)
                return Just(recipes)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                print("error:\(error)")
            }
        }
        return Fail(error: "Error" as! Error).eraseToAnyPublisher()
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await session.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
