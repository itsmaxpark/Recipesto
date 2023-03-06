//
//  Recipe.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import Foundation


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

// MARK: - UserRatings
struct UserRatings: Codable, Hashable {
    let score: Double?
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
    let ingredient: Ingredient
    let measurements: [Measurement]
}

// MARK: - Ingredient
struct Ingredient: Codable, Hashable {
    let name: String
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
