//
//  Misc.swift
//  Guess The Doodle
//
//  Created by salih kocatürk on 12.06.2024.
//

import Foundation
let everydayObjects: [String] = [
    "apple", "book", "car", "door", "envelope", "fork", "glass", "hat", "iron", "key",
    "lamp", "mirror", "notebook", "orange", "pen", "quilt", "radio", "shoe", "table", "umbrella",
    "vase", "watch", "xylophone", "yarn", "zipper", "basket", "clock", "dish", "eraser", "flag",
    "guitar", "hanger", "ice", "jacket", "lemon", "mop", "needle", "orange", "pillow", "queen",
    "ruler", "shampoo", "toothbrush", "umbrella", "violin", "wallet", "xylophone", "yoyo", "zipper",
    "camera", "desk", "egg", "fork", "glasses", "hammer", "ipad", "jacket", "key", "lemon",
    "matches", "nail", "oven", "pencil", "quilt", "rake", "spoon", "table", "umbrella", "violin",
    "whistle", "xylophone", "yarn", "zebra", "zipper", "bag", "chair", "dress", "eraser", "fan",
    "gloves", "hat", "ink", "jeans", "key", "lipstick", "monitor", "nail", "orange", "purse",
    "quilt", "rug", "shoes", "toothbrush", "umbrella", "vase", "wallet", "xylophone", "yarn", "zipper"
]
enum PlayerAuthState: String {
    case authenticating = "Logging in to Game Center..."
    case unauthenticated = "Please sign in to Game Center to play."
    case authenticated = "Authenticated"
    
    case error = "There was an error logging into Game Center."
    case restricted = "You're not allowed to play multiplayer games!"
}

struct PastGuess: Identifiable{
    let id = UUID()
    var message: String
    var correct: Bool
}

let maxTimeRemaining = 100
