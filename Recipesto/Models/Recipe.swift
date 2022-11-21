//
//  Recipe.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import Foundation

struct Recipe: Codable {
    
}

// MARK: - Result
struct Result: Codable {
    let type: String
    let name, category: String?
    let minItems: Int?
    let items: [ItemElement]?

    enum CodingKeys: String, CodingKey {
        case type, item, name, category
        case minItems = "min_items"
        case items
    }
}

// MARK: - ItemElement
struct ItemElement: Codable {
    let keywords: String?
    let thumbnailURL: String
    let videoURL: String
    let credits: [Brand]
    let id: Int
    let recipes: [FluffyRecipe]?
    let tags: [Tag]
    let name: String
    let instructions: [Instruction]?
    let userRatings: UserRatings?
    let prepTimeMinutes: Int?
    let sections: [ItemSection]?
    let compilations: [Compilation]?
    let numServings: Int?
    let totalTimeMinutes: Int?
    let topics: [Topic]?
    let cookTimeMinutes: Int?

}
