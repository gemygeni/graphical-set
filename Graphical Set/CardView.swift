//
//  CardView.swift
//  Graphical Set
//
//  Created by Susana on 2/16/18.
//  Copyright © 2018 SF. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    // MARK: properties
    // initialize with default values, which will be overridden before drawing
    
    var color = Card.Color.pink { didSet { setNeedsDisplay() }}
    var number = Card.Number.one.rawValue { didSet { setNeedsDisplay() }}
    var shading = Card.Shading.open { didSet { setNeedsDisplay() }}
    var symbol = Card.Symbol.diamond { didSet { setNeedsDisplay() }}
    
    var borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor {
        didSet {
            layer.borderColor = borderColor
        }
    }
    
    var borderWidth = CGFloat(0.0) {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    private lazy var grid = Grid(layout: .dimensions(rowCount: 3, columnCount: 1), frame: bounds)
    
    // MARK: public methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        grid.frame = bounds
        drawBackground()
        drawShapes()
    }
    
    func drawShapes() {
        for cellIndex in 0..<number {
            setStrokeAndFillColor()
        
            if let cellFrame = grid[cellIndex] {
                let shapePath = getShapePath(for: cellIndex, within: cellFrame)
                
                switch shading {
                case .open:
                    shapePath.stroke()
                case .solid:
                    shapePath.fill()
                case .striped:
                    drawStripes(in: shapePath, within: cellFrame)
                }
            }
        }
    }
    
    // MARK: private methods
    
    private func drawBackground() {
        
        // set white background
        guard let graphicsContext = UIGraphicsGetCurrentContext() else {
            print("unable to get graphics context in drawBackground()")
            return
        }
        
        Color.white.setFill()
        graphicsContext.fill(bounds)
        
        // draw rectangle with rounded corners
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        Color.cardBackgroundColor.setFill()
        roundedRect.fill()
    }
    
    private func setStrokeAndFillColor() {
        switch color {
        case .pink:
            Color.pink.setStroke()
            Color.pink.setFill()
        case .purple:
            Color.purple.setStroke()
            Color.purple.setFill()
        case .teal:
            Color.teal.setStroke()
            Color.teal.setFill()
        }
    }
    
    private func getShapePath(for cellNumber: Int, within bounds: CGRect) -> UIBezierPath {
        switch symbol {
        case .diamond:
            return getDiamondPath(for: cellNumber, within: bounds)
        case .oval:
            return UIBezierPath(ovalIn: bounds.insetBy(dx: SizeRatio.gridInset, dy: SizeRatio.gridInset))
        case .squiggle:
            return getSquigglePath(for: cellNumber, within: bounds)
        }
    }
    
    private func getDiamondPath(for cellNumber: Int, within bounds: CGRect) -> UIBezierPath {
        let diamondPath = UIBezierPath()
        let cellOffset = bounds.height * CGFloat(cellNumber)
        
        diamondPath.move(to: CGPoint(x: bounds.midX,
                                     y: cellOffset + SizeRatio.gridInset))
        diamondPath.addLine(to: CGPoint(x: bounds.maxX - SizeRatio.gridInset,
                                        y: (bounds.height / 2) + cellOffset))
        diamondPath.addLine(to: CGPoint(x: bounds.midX,
                                        y: bounds.height + cellOffset - SizeRatio.gridInset))
        diamondPath.addLine(to: CGPoint(x: bounds.minX + SizeRatio.gridInset,
                                        y: bounds.height / 2 + cellOffset))
        diamondPath.close()
        
        return diamondPath
    }
    
    private func getSquigglePath(for cellNumber: Int, within bounds: CGRect) -> UIBezierPath {
        let squigglePath = UIBezierPath()
        let cellOffset = bounds.height * CGFloat(cellNumber)
        let oneThirdWidth = bounds.width / 3
        let oneThirdHeight = bounds.height / 3
        
        squigglePath.move(to: CGPoint(x: bounds.minX + SizeRatio.gridInset,
                                      y: oneThirdHeight + cellOffset))
        squigglePath.addCurve(to: CGPoint(x: bounds.maxX - SizeRatio.gridInset,
                                          y: oneThirdHeight + cellOffset),
                              controlPoint1: CGPoint(x: oneThirdWidth,
                                                     y: squiggleHeight + cellOffset),
                              controlPoint2: CGPoint(x: bounds.maxX - (bounds.width / 3),
                                                     y: (bounds.height * 0.6) + squiggleHeight + cellOffset))
        squigglePath.addLine(to: CGPoint(x: bounds.maxX - SizeRatio.gridInset,
                                         y: bounds.height - oneThirdHeight + cellOffset))
        squigglePath.addCurve(to: CGPoint(x: bounds.minX + SizeRatio.gridInset,
                                          y: bounds.height - oneThirdHeight + cellOffset),
                              controlPoint1: CGPoint(x: bounds.maxX - oneThirdWidth,
                                                     y: bounds.height + squiggleHeight + cellOffset),
                              controlPoint2: CGPoint(x: oneThirdWidth,
                                                     y: oneThirdHeight + squiggleHeight + cellOffset))
        squigglePath.close()
        
        return squigglePath
    }
    
    private func drawStripes(in shapePath: UIBezierPath, within bounds: CGRect) {
        let yCoord = bounds.maxY
        let numStripes = Int(bounds.width / SizeRatio.stripeInterval)
        
        UIGraphicsGetCurrentContext()?.saveGState()
        shapePath.addClip()
        
        for x in 0..<numStripes {
            let xCoord = CGFloat(x)
            
            shapePath.move(to: CGPoint(x: xCoord * SizeRatio.stripeInterval, y: 0))
            shapePath.addLine(to: CGPoint(x: xCoord * SizeRatio.stripeInterval, y: yCoord))
        }
        
        shapePath.stroke()
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
}

// extension for color literals
extension CardView {
    private struct Color {
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let cardBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        static let pink = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        static let purple = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        static let teal = #colorLiteral(red: 0.1554745199, green: 0.612707145, blue: 0.7078045685, alpha: 1)
    }
}

// extension for card size calculations
extension CardView {
    private struct SizeRatio {
        static let gridInset: CGFloat = 10
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let diamondSideLengthMultiplier: CGFloat = 0.2
        static let squiggleHeightMultiplier: CGFloat = 0.01
        static let stripeInterval: CGFloat = 3
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var diamondSideLength: CGFloat {
        return bounds.size.height * SizeRatio.diamondSideLengthMultiplier
    }
    
    private var squiggleHeight: CGFloat {
        return bounds.size.height * SizeRatio.squiggleHeightMultiplier
    }
}
