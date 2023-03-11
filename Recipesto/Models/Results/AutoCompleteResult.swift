//
//  AutoCompleteResult.swift
//  Recipesto
//
//  Created by Max Park on 3/9/23.
//

import Foundation

struct AutoCompleteResult: Hashable, Codable {
    var display, searchValue, type: String
}
