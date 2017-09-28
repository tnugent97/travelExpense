//
//  gradientView.swift
//  The Wikipedia Game
//
//  Created by Thomas Nugent on 20/07/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

@IBDesignable
class gradientView: UIView {

    @IBInspectable var FirstColour: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColour: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ FirstColour.cgColor, SecondColour.cgColor ]
        layer.locations = [ 0.6 ]
    }

}
