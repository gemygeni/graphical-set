//
//  Card.swift
//  Set
//
//  Created by Susana on 2/9/18.
//  Copyright © 2018 SF. All rights reserved.
//

import Foundation

struct Card {
    
    // MARK: properties
    
    let number: Number
    let symbol: Symbol
    let shading: Shading
    let color: Color
    
    // MARK: enums
    
    enum Number: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var all: [Number] {
            return [.one, .two, .three]
        }
    }
    
    enum Symbol: Character {
        case circle = "●"
        case triangle = "▲"
        case square = "■"
        
        static var all: [Symbol] {
            return [.circle, .triangle, .square]
        }
    }
    
    enum Shading {
        case solid
        case striped
        case open
        
        static var all: [Shading] {
            return [.solid, .striped, .open]
        }
    }
    
    enum Color {
        case teal
        case pink
        case purple
        
        static var all: [Color] {
            return [.teal, .pink, .purple]
        }
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return
            (lhs.color == rhs.color) &&
                (lhs.number == rhs.number) &&
                (lhs.shading == rhs.shading) &&
                (lhs.symbol == rhs.symbol)
    }
}

