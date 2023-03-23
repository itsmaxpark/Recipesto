//
//  SwipeRecipeResponder.swift
//  Recipesto
//
//  Created by Max Park on 3/22/23.
//

import Foundation
import Combine

protocol SwipeRecipeResponder {
    func getSwipeRecipe() -> AnyPublisher<Item, RPError>
}
