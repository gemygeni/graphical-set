//
//  ViewController.swift
//  Set
//
//  Created by Susana on 2/9/18.
//  Copyright © 2018 SF. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: properties
    
    private var setGame = Set()
    
    // MARK: outlets and actions
    
    @IBOutlet private var dealCardsButton: UIButton!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private var scoreLabel: UILabel!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.index(of: sender) {
            setGame.selectCard(at: cardIndex)
            updateView()
        }
    }
    
    @IBAction func dealThreeCards(_ sender: UIButton) {
        setGame.dealThreeCards()
        updateView()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        setGame.reset()
        updateView()
    }
    
    // MARK: public functions
    
    override func viewDidLoad() {
        updateView()
    }
    
    // MARK: private functions
    
    private func updateView() {
        updateScoreLabel()
        drawCardButtons()
        dealCardsButton.isEnabled = canDealMoreCards()
    }
    
    private func drawCardButtons() {
        let cardsInPlay = setGame.cardsInPlay
        
        // draw buttons for cards in play
        for index in cardsInPlay.indices {
            let card = cardsInPlay[index]
            let cardButton = cardButtons[index]
            
            cardButton.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            cardButton.setAttributedTitle(getTitleAttributesFor(card), for: .normal)
            addButtonBorders()
        }
        
        // make rest of buttons invisible
        for index in cardsInPlay.count..<cardButtons.count {
            let cardButton = cardButtons[index]
            
            cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cardButton.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            cardButton.layer.borderWidth = 0.0
        }
    }
    
    // return true if not enough cards in deck or no more room in UI to fit more cards
    private func canDealMoreCards() -> Bool {
        return setGame.deck.count >= 3 && setGame.cardsInPlay.count <= 21
    }
    
    // returns dictionary of attributes to properly display text on card buttons
    private func getTitleAttributesFor(_ card: Card) -> NSAttributedString {
        var attributes = [NSAttributedStringKey: Any]()
        let cardText = getCardString(from: card)
        let foregroundColor = getForegroundColor(from: card)
        
        switch card.shading {
        case .open:
            attributes[NSAttributedStringKey.strokeWidth] = 7.0
            attributes[NSAttributedStringKey.strokeColor] = foregroundColor
        case .solid:
            attributes[NSAttributedStringKey.foregroundColor] = foregroundColor.withAlphaComponent(1.0)
        case .striped:
            attributes[NSAttributedStringKey.foregroundColor] = foregroundColor.withAlphaComponent(0.35)
        }
        
        return NSAttributedString(string: cardText, attributes: attributes)
    }
    
    // given card, return the text that should appear on the card button
    private func getCardString(from card: Card) -> String {
        var cardText = ""
        
        for _ in 0..<card.number.rawValue {
            cardText.append(card.symbol.rawValue)
        }
        
        return cardText
    }
    
    // given card, return the color that the text should be on the card button
    private func getForegroundColor(from card: Card) -> UIColor {
        let color: UIColor
        
        switch card.color {
        case .pink:
            color = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        case .purple:
            color = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        case .teal:
            color = #colorLiteral(red: 0.2353998017, green: 0.504123101, blue: 0.5628422499, alpha: 1)
        }
        
        return color
    }
    
    // draw borders to indicate selection and correct or incorrect matches,
    // if appropriate
    private func addButtonBorders() {
        let selectedCards = setGame.selectedCards
        let cardsInPlay = setGame.cardsInPlay
        
        for index in cardsInPlay.indices {
            let card = cardsInPlay[index]
            let cardButton = cardButtons[index]
            
            if selectedCards.contains(card) {
                cardButton.layer.borderWidth = 2.0
                
                if selectedCards.count < 3 {
                    cardButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                } else {
                    cardButton.layer.borderColor = setGame.hasMatch ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                }
            } else {
                cardButton.layer.borderWidth = 0.0
            }
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(setGame.score)"
    }
}
