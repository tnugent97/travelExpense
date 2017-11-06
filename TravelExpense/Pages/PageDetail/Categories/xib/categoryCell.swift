//
//  categoryCell.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 28/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class categoryCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
