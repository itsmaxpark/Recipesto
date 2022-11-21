//
//  RPError.swift
//  Recipesto
//
//  Created by Max Park on 11/20/22.
//

import Foundation

enum RPError: String, Error {
    
    case invalidUsername = "This username created an invalid request"
    case unableToComplete = "Unable to complete your request"
    case invalidResponse = "Invalid response from the server"
    case invalidData = "Invalid data received"
    case unableToFavorite = "There was an error favoriting this user"
    case alreadyInFavorites = "You've already favorited this user"
}
