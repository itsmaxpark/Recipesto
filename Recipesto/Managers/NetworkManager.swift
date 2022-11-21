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
    
    func getFeaturedRecipes(page: Int, isVegetarian: Bool) async throws -> [Recipe] {
        
        let endpoint = baseURL + "feeds/list?size=\(size)&timezone=%2B0500&vegetarian=false&from=\(page)"
        
        guard let url = URL(string: endpoint) else { throw RPError.unableToComplete }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw RPError.invalidResponse }
        
        do {
            return try decoder.decode([Recipe].self, from: data)
        } catch {
            throw RPError.invalidData
        }
        
//        let request = NSMutableURLRequest(url: NSURL(string: "https://tasty.p.rapidapi.com/feeds/list?size=\(size)&timezone=%2B0500&vegetarian=false&from=\(page)")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error)
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse)
//            }
//        })
//
//        dataTask.resume()
    }
}
