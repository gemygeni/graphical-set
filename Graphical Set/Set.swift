//
//  Set.swift
//  Set
//
//  Created by Susana on 2/9/18.
//  Copyright © 2018 SF. All rights reserved.
//

import Foundation
import GameplayKit.GKRandomSource

class Set {
    
    // MARK: properties
    
    private(set) var deck = [Card]()
    private(set) var cardsInPlay = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var hasMatch = false
    private(set) var score = 0
    
    // MARK: public functions
    
    init() {
        initDeck()
        draw(numCards: GameConstant.numInitialCards)
    }
    
    func selectCard(at index: Int) {
        hasMatch = false
        
        if (index >= 0 && index < cardsInPlay.count) {
            let card = cardsInPlay[index]
            
            // deselect card if it's already been selected and fewer
            // than 3 cards have been selected
            // else select the card
            if selectedCards.count < GameConstant.numCardsPerSet {
                if let selectedCardIndex = selectedCards.index(of: card) {
                    selectedCards.remove(at: selectedCardIndex)
                } else {
                    selectedCards.append(card)
                    hasMatch = selectedCardsAreMatch()
                }
            }
                
                // this block executes when 4th card is selected
                // (selected card has not yet been added to selectedCard)
            else if selectedCards.count == GameConstant.numCardsPerSet {
                if checkForMatch() {
                    draw(numCards: GameConstant.numCardsPerDeal)
                    score += GameConstant.matchedSetPoints
                } else {
                    score += GameConstant.incorrectSetPenalty
                }
                
                // if the selected card was already matched,
                // selectedCards should be empty
                selectedCards = selectedCards.contains(card) ? [] : [card]
            }
        }
    }
    
    func dealCards() {
        if checkForMatch() {
            selectedCards.removeAll()
        }
        
        draw(numCards: GameConstant.numCardsPerDeal)
        score += GameConstant.dealCardsPenalty
    }
    
    func canDealMoreCards() -> Bool {
        return deck.count >= GameConstant.numCardsPerDeal
    }
    
    func reset() {
        deck.removeAll()
        cardsInPlay.removeAll()
        selectedCards.removeAll()
        hasMatch = false
        score = 0
        
        initDeck()
        draw(numCards: GameConstant.numInitialCards)
    }
    
    // MARK: private functions
    
    private func initDeck() {
        for num in Card.Number.all {
            for symbol in Card.Symbol.all {
                for shade in Card.Shading.all {
                    for color in Card.Color.all {
                        deck.append(Card(number: num,
                                         symbol: symbol,
                                         shading: shade,
                                         color: color))
                    }
                }
            }
        }
        
        deck = shuffle(deck)
    }
    
    private func draw(numCards: Int) {
        if deck.count >= numCards {
            for _ in 1...numCards {
                if let drawnCard = deck.popLast() {
                    cardsInPlay.append(drawnCard)
                }
            }
        }
    }
    
    private func shuffle(_ deck: [Card]) -> [Card] {
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: deck) as! [Card]
    }
    
    // if selected cards are a match, remove them from cardsInPlay
    private func checkForMatch() -> Bool {
        hasMatch = selectedCardsAreMatch()
        
        if hasMatch {
            for card in selectedCards {
                if let index = cardsInPlay.index(of: card) {
                    cardsInPlay.remove(at: index)
                }
            }
        }
        
        return hasMatch
    }
    
    // return true if selected cards are a set or return false otherwise
    private func selectedCardsAreMatch() -> Bool {
        if selectedCards.count < GameConstant.numCardsPerSet {
            return false
        }
        
        let card1 = selectedCards[0]
        let card2 = selectedCards[1]
        let card3 = selectedCards[2]
        
        // check for color
        if (!((card1.color == card2.color) && (card1.color == card3.color) ||
            (card1.color != card2.color) && (card1.color != card3.color) && (card2.color != card3.color))) {
            return false
        }
        
        // check for number
        if (!((card1.number == card2.number) && (card1.number == card3.number) ||
            (card1.number != card2.number) && (card1.number != card3.number) && (card2.number != card3.number))) {
            return false
        }
        
        // check for symbol
        if (!((card1.symbol == card2.symbol) && (card1.symbol == card3.symbol) ||
            (card1.symbol != card2.symbol) && (card1.symbol != card3.symbol) && (card2.symbol != card3.symbol))) {
            return false
        }
        
        // check for shading
        if (!((card1.shading == card2.shading) && (card1.shading == card3.shading) ||
            (card1.shading != card2.shading) && (card1.shading != card3.shading) && (card2.shading != card3.shading))) {
            return false
        }
        
        return true
    }
}

extension Set {
    private struct GameConstant {
        static let numInitialCards: Int = 12
        static let numCardsPerDeal: Int = 3
        static let numCardsPerSet: Int = 3
        
        static let dealCardsPenalty: Int = -3
        static let incorrectSetPenalty: Int = -10
        static let matchedSetPoints: Int = 5
    }
}

