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
    private lazy var grid = Grid(layout: .aspectRatio(CardSize.aspectRatio),
                                 frame: cardsInPlayView.bounds)
    
    // MARK: outlets
    
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var dealButton: UIButton!
    @IBOutlet private var newGameButton: UIButton!
    @IBOutlet private var cardsInPlayView: UIView!
    
    // MARK: actions
    
    @IBAction func dealCards(_ sender: UIButton) {
        setGame.dealCards()
        updateView()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        setGame.reset()
        updateView()
    }
    
    @IBAction func handleCardTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: cardsInPlayView)
            
            if let tappedView = cardsInPlayView.hitTest(location, with: nil) {
                if let cardIndex = cardsInPlayView.subviews.index(of: tappedView) {
                    setGame.selectCard(at: cardIndex)
                    updateView()
                }
            }
        }
    }
    
    // MARK: public functions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addCardViewsToGrid()
    }
    
    // MARK: private functions
    
    private func updateView() {
        addCardViewsToGrid()
        addBorders()
    }
    
    private func addCardViewsToGrid() {
        grid.frame = cardsInPlayView.bounds
        grid.cellCount = setGame.cardsInPlay.count
        
        for cardView in cardsInPlayView.subviews {
            cardView.removeFromSuperview()
        }
        
        for index in 0..<grid.cellCount {
            if let cellFrame = grid[index] {
                let card = setGame.cardsInPlay[index]
                let cardView = CardView(frame: cellFrame.insetBy(dx: CardSize.inset, dy: CardSize.inset))
                
                cardView.color = card.color
                cardView.number = card.number.rawValue
                cardView.shading = card.shading
                cardView.symbol = card.symbol
                
                cardsInPlayView.addSubview(cardView)
            } else {
                print("grid[\(index)] does not exist")
            }
        }
    }
    
    private func addBorders() {
        let selectedCards = setGame.selectedCards
        let cardsInPlay = setGame.cardsInPlay

        for index in cardsInPlay.indices {
            let card = cardsInPlay[index]
            let cardView = cardsInPlayView.subviews[index] as! CardView

            if selectedCards.contains(card) {
                cardView.borderWidth = CardSize.borderWidth

                if selectedCards.count < 3 {
                    cardView.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                } else {
                    cardView.borderColor = setGame.hasMatch ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                }
            } else {
                cardView.borderWidth = 0.0
            }
        }
    }
}

extension ViewController {
    private struct CardSize {
        static let aspectRatio: CGFloat = 0.7
        static let borderWidth: CGFloat = 2.0
        static let inset: CGFloat = 4.0
    }
}
