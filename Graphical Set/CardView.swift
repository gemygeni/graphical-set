//
//  CardView.swift
//  Graphical Set
//
//  Created by Susana on 2/16/18.
//  Copyright © 2018 SF. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    // MARK: public methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBackground()
    }
    
    // MARK: private methods
    
    private func drawBackground() {
        
        // set white background
        Color.white.setFill()
        if let graphicsContext = UIGraphicsGetCurrentContext() {
            graphicsContext.fill(bounds)
        }
        
        // draw rectangle with rounded corners
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        Color.backgroundColor.setFill()
        roundedRect.fill()
    }
}

// extension for color literals
extension CardView {
    private struct Color {
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        static let pink = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        static let purple = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        static let teal = #colorLiteral(red: 0.1554745199, green: 0.612707145, blue: 0.7078045685, alpha: 1)
    }
}

// extension for card size calculations
extension CardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
}
