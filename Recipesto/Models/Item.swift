//
//  Item.swift
//  Recipesto
//
//  Created by Max Park on 3/5/23.
//

import Foundation

// MARK: - Item
struct Item: Codable, Hashable {
    
    let credits: [Brand]
    let recipes: [Recipe]?
    let tags: [Tag]
    let instructions: [Instruction]?
    let userRatings: UserRatings?
    let sections: [Section]? // IngredientSection
    let compilations: [Compilation]?
    let keywords, thumbnailUrl, videoUrl: String?
    let totalTimeMinutes, prepTimeMinutes, cookTimeMinutes, numServings: Int?
    let name: String
    let id: Int

}
