//
//  Recipe.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import Foundation

// MARK: - Result
struct Result: Codable, Hashable, Identifiable {
    var id = UUID()
    
    let type: String
    let name, category: String?
    let minItems: Int?
    let items: [Item]?
    let item: Item?
}

extension Result {
    enum CodingKeys: CodingKey {
        case type
        case name, category
        case minItems
        case items
        case item
    }
}

// MARK: - Item
struct Item: Codable, Hashable {
    let credits: [Brand]
    let recipes: [Recipe]?
    let tags: [Tag]
    let instructions: [Instruction]?
    let userRatings: UserRatings?
    let sections: [Section]?
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

// MARK: - Recipe
struct Recipe: Codable, Hashable {
    let credits: [Brand]?
    let instructions: [Instruction]?
    let userRatings: UserRatings?
    let sections: [Section]?
    let nutrition: Nutrition?
    let keywords: String?
    let name: String?
    let thumbnailURL: String?
    let videoURL: String?
    let yields: String?
    let prepTimeMinutes: Int?
    let numServings: Int?
    let totalTimeMinutes: Int?
    let cookTimeMinutes: Int?
}

// MARK: - Brand
struct Brand: Codable, Hashable {
    let name: String?
}

// MARK: - Tag
struct Tag: Codable, Hashable {
    let name: String
}

// MARK: - Instruction
struct Instruction: Codable, Hashable {
    let position: Int
    let displayText: String
}

// MARK: - UserRatings
struct UserRatings: Codable, Hashable {
    let score: Double
}

// MARK: - Section
struct Section: Codable, Hashable {
    let components: [Component]
    let name: String?
    let position: Int
}

// MARK: - Component
struct Component: Codable, Hashable {
    let rawText: String
    let position: Int
}

// MARK: - Compilation
struct Compilation: Codable, Hashable {
    let description: String?
}

// MARK: - Nutrition
struct Nutrition: Codable, Hashable {
    let carbohydrates, fiber: Int?
    let protein, fat, calories, sugar: Int?
}
