//
//  Measurement.swift
//  Recipesto
//
//  Created by Max Park on 3/5/23.
//

import Foundation

// MARK: - Measurement
struct Measurement: Codable, Hashable {
    let unit: Unit
    let quantity: String
}

// MARK: - Unit
struct Unit: Codable, Hashable {
    let system: String
    let name: String
    let displayPlural: String
    let displaySingular: String
    let abbreviation: String
}
