//
//  Instruction.swift
//  Recipesto
//
//  Created by Max Park on 3/5/23.
//

import Foundation

// MARK: - Instruction
struct Instruction: Codable, Hashable {
    let position: Int
    let displayText: String
}
