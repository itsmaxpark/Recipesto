//
//  NetworkSession.swift
//  Recipesto
//
//  Created by Max Park on 3/23/23.
//

import Foundation
import Combine

protocol NetworkSession {
    func getRandomRecipe() -> AnyPublisher<RecipeResult, Error>
}
