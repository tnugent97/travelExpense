//
//  EmptyTableView.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 14/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class EmptyTableView: UIView {

    func instanceFromNib() -> UIView {
        return UINib(nibName: "EmptyTableView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
