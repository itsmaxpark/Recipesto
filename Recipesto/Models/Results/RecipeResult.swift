//
//  SwipeRecipeResult.swift
//  Recipesto
//
//  Created by Max Park on 3/9/23.
//

import Foundation

struct RecipeResult: Codable, Hashable {
    let count: Int
    let results: [Item]
}
