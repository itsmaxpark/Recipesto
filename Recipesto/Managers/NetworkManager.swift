//
//  NetworkManager.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://tasty.p.rapidapi.com/"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    let size: String = "5"
    
    let headers = [
        "X-RapidAPI-Key": "6642e055e4mshe3a29e133f03767p1b5e21jsnc9fa55d6ea3b",
        "X-RapidAPI-Host": "tasty.p.rapidapi.com"
    ]

    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getFeaturedRecipes(page: Int, isVegetarian: Bool) async throws -> [String: [Result]] {
        
        let endpoint = baseURL + "feeds/list?size=\(size)&timezone=%2B0500&vegetarian=false&from=\(page)"
        
        guard let url = URL(string: endpoint) else { throw RPError.unableToComplete }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw RPError.invalidResponse }
        
        do {
            return try decoder.decode([String: [Result]].self, from: data)
        } catch {
            print(error)
            throw RPError.invalidData
        }
        
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
