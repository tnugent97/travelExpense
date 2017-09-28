//
//  EmptyTableView.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 14/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class EmptyPageDetailView: UIView {

    func instanceFromNib() -> UIView {
        return UINib(nibName: "EmptyPageDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
