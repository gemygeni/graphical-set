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
    private lazy var grid = Grid(layout: .aspectRatio(CardSize.cardAspectRatio),
                                 frame: cardsInPlayView.bounds)
    
    // MARK: outlets and actions
    
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var dealButton: UIButton!
    @IBOutlet private var newGameButton: UIButton!
    @IBOutlet private var cardsInPlayView: UIView!
    
    // MARK: public functions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addCardViewsToGrid()
    }
    
    // MARK: private functions
    
    private func addCardViewsToGrid() {
        grid.frame = cardsInPlayView.bounds
        grid.cellCount = setGame.cardsInPlay.count
        
        for cardView in cardsInPlayView.subviews {
            cardView.removeFromSuperview()
        }
        
        for index in 0..<grid.cellCount {
            if let cellFrame = grid[index] {
                let card = setGame.cardsInPlay[index]
                let cardView = CardView(frame: cellFrame.insetBy(dx: CardSize.cardInset,
                                                                 dy: CardSize.cardInset))
                
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
}

extension ViewController {
    private struct CardSize {
        static let cardAspectRatio: CGFloat = 0.7
        static let cardInset: CGFloat = 4
    }
}
