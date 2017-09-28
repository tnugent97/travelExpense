//
//  RoundButton.swift
//  The Wikipedia Game
//
//  Created by Thomas Nugent on 20/07/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColour: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColour.cgColor
        }
    }

}
