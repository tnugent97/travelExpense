//
//  settingsViewControllerTableViewController.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 14/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class settingsViewController: UITableViewController {
    
    @IBOutlet weak var homeCurrencyChoice: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
