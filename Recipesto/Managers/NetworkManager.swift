//
//  NetworkManager.swift

import UIKit
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://tasty.p.rapidapi.com/"
    let cache = NSCache<NSString, UIImage>()
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    let size: String = "5"
    
    let headers = [
        "X-RapidAPI-Key": "6642e055e4mshe3a29e133f03767p1b5e21jsnc9fa55d6ea3b",
        "X-RapidAPI-Host": "tasty.p.rapidapi.com"
    ]
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Returns a RecipeResult to be used by the SearchController from the given searchText
    func getSearchRecipe(tags: String, searchText: String) async throws -> RecipeResult {
        let url = EndPoint.search(tags: tags, searchText: searchText).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await session.data(for: request)
        
        guard let
            response = response as? HTTPURLResponse,
            response.statusCode == 200
        else { throw RPError.invalidResponse }
        
        do {
            return try decoder.decode(RecipeResult.self, from: data)
        } catch {
            throw RPError.invalidData
        }
    }
    
    /// Returns a random recipe to be used on the SwipeVC
    func getSwipeRecipe(tags: String) async throws -> RecipeResult {
        let url = EndPoint.swipe(tags: tags).url
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await session.data(for: request)
        
        guard let
            response = response as? HTTPURLResponse,
            response.statusCode == 200
        else { throw RPError.invalidResponse }
        
        do {
            return try decoder.decode(RecipeResult.self, from: data)
        } catch {
            throw RPError.invalidData
        }
    }
    
    /// Returns the list of recipes to be shown on the BrowseVC
    func getBrowseRecipes() async throws -> [String: [Result]] {
        let url = EndPoint.browse.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw RPError.invalidResponse }
        
        do {
            return try decoder.decode([String: [Result]].self, from: data)
        } catch {
            throw RPError.invalidData
        }
        
    }
    
    /// Returns a UIImage from a given URL or from the cache
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

extension NetworkManager {
    func getAutoCompleteSuggestion(text: String) async throws -> [String: [AutoCompleteResult]] {
        let endpoint = baseURL + "recipes/auto-complete?prefix=\(text)"
        
        guard let url = URL(string: endpoint) else { throw RPError.unableToComplete }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw RPError.invalidResponse }
        
        do {
            return try decoder.decode([String: [AutoCompleteResult]].self, from: data)
        } catch {
            print(error)
            throw RPError.invalidData
        }
    }
    func getSwipeRecipe() -> AnyPublisher<RecipeResult, Error> {
        let endpoint = baseURL + "recipes/list?from=0&size=20"
        
        guard let url = URL(string: endpoint) else { return Fail(error: RPError.unableToComplete).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return session.dataTaskPublisher(for: request)
            .tryMap({ (data, response) -> Data in
                if let response = response as? HTTPURLResponse,
                   (200..<300).contains(response.statusCode) == false {
                    throw RPError.invalidResponse
                }
                return data
            })
            .decode(type: RecipeResult.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
