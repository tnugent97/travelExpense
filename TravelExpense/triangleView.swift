//
//  triangleView.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 31/07/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class triangleView: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.closePath()
        
        context.setFillColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        context.fillPath()

    }
    
    
    

}
