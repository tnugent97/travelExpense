//
//  customPageDetailCell.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 15/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class customPageDetailCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
