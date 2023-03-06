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
    let keywords: String?
    let thumbnailUrl: String?
    let videoUrl: String?
    let name: String
    let id: Int
    let prepTimeMinutes: Int?
    let numServings: Int?
    let totalTimeMinutes: Int?
    let cookTimeMinutes: Int?

}
