//
//  customCell.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 17/08/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class customPageCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var localCurrency: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var lastEdited: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
