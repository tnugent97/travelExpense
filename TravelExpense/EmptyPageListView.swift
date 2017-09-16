//
//  EmptyTableView.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 14/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class EmptyPageListView: UIView {

    func instanceFromNib() -> UIView {
        return UINib(nibName: "EmptyPageListView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
