//
//  Result.swift
//  Recipesto
//
//  Created by Max Park on 3/5/23.
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
