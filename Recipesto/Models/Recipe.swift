//
//  Recipe.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import Foundation

// MARK: - Result
struct Result: Codable, Hashable {
    let type: String
    let name, category: String?
    let minItems: Int?
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable, Hashable {
    let keywords: String?
    let thumbnailURL: String?
    let videoURL: String?
    let credits: [Brand]
    let id: Int
    let recipes: [Recipe]?
    let tags: [Tag]
    let name: String
    let instructions: [Instruction]?
    let userRatings: UserRatings?
    let prepTimeMinutes: Int?
    let sections: [Section]?
    let compilations: [Compilation]?
    let numServings: Int?
    let totalTimeMinutes: Int?
    let cookTimeMinutes: Int?

}

// MARK: - Recipe
struct Recipe: Codable, Hashable {
    let instructions: [Instruction]
    let keywords: String?
    let userRatings: UserRatings
    let prepTimeMinutes: Int?
    let sections: [Section]
    let nutrition: Nutrition
    let name: String
    let numServings: Int
    let thumbnailURL: String?
    let totalTimeMinutes: Int?
    let videoURL: String?
    let credits: [Brand]
    let yields: String
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
