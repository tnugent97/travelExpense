//
//  HomeCurrencyController.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 15/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit

class HomeCurrencyController: UITableViewController {
    
    
    @IBOutlet weak var noneCell: UITableViewCell!
    @IBOutlet weak var audCell: UITableViewCell!
    @IBOutlet weak var bgnCell: UITableViewCell!
    @IBOutlet weak var brlCell: UITableViewCell!
    @IBOutlet weak var cadCell: UITableViewCell!
    @IBOutlet weak var chfCell: UITableViewCell!
    @IBOutlet weak var cnyCell: UITableViewCell!
    @IBOutlet weak var czkCell: UITableViewCell!
    @IBOutlet weak var dkkCell: UITableViewCell!
    @IBOutlet weak var eurCell: UITableViewCell!
    @IBOutlet weak var gbpCell: UITableViewCell!
    @IBOutlet weak var hkdCell: UITableViewCell!
    @IBOutlet weak var hrkCell: UITableViewCell!
    @IBOutlet weak var hufCell: UITableViewCell!
    @IBOutlet weak var idrCell: UITableViewCell!
    @IBOutlet weak var ilsCell: UITableViewCell!
    @IBOutlet weak var inrCell: UITableViewCell!
    @IBOutlet weak var jpyCell: UITableViewCell!
    @IBOutlet weak var krwCell: UITableViewCell!
    @IBOutlet weak var myrCell: UITableViewCell!
    @IBOutlet weak var mxnCell: UITableViewCell!
    @IBOutlet weak var nokCell: UITableViewCell!
    @IBOutlet weak var nzdCell: UITableViewCell!
    @IBOutlet weak var phpCell: UITableViewCell!
    @IBOutlet weak var plnCell: UITableViewCell!
    @IBOutlet weak var ronCell: UITableViewCell!
    @IBOutlet weak var rubCell: UITableViewCell!
    @IBOutlet weak var sekCell: UITableViewCell!
    @IBOutlet weak var sgdCell: UITableViewCell!
    @IBOutlet weak var thbCell: UITableViewCell!
    @IBOutlet weak var tryCell: UITableViewCell!
    @IBOutlet weak var usdCell: UITableViewCell!
    @IBOutlet weak var zarCell: UITableViewCell!
    
    let defaults = UserDefaults.standard
    var homeCurrencyChoice : Int?
    var sourceVC : settingsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCurrencyChoice = defaults.object(forKey: "homeCurrency") as? Int
        
        if (homeCurrencyChoice == nil) || (homeCurrencyChoice == 0) {
            //no selection yet
            noneCell.accessoryType = .checkmark
            homeCurrencyChoice = 0
        }
        else{
            toggleCheckMark(currency: homeCurrencyChoice!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table view functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != homeCurrencyChoice{
            toggleCheckMark(currency: indexPath.row)
            toggleCheckMark(currency: homeCurrencyChoice!)
            homeCurrencyChoice = indexPath.row
            defaults.set(homeCurrencyChoice, forKey: "homeCurrency")
        }
    }
    
    func toggleCheckMark(currency: Int){
        let cell : UITableViewCell
        switch(currency){
        case 1:
            cell = audCell
            break
        case 2:
            cell = bgnCell
            break
        case 3:
            cell = brlCell
            break
        case 4:
            cell = cadCell
            break
        case 5:
            cell = chfCell
            break
        case 6:
            cell = cnyCell
            break
        case 7:
            cell = czkCell
            break
        case 8:
            cell = dkkCell
            break
        case 9:
            cell = eurCell
            break
        case 10:
            cell = gbpCell
            break
        case 11:
            cell = hkdCell
            break
        case 12:
            cell = hrkCell
            break
        case 13:
            cell = hufCell
            break
        case 14:
            cell = idrCell
            break
        case 15:
            cell = ilsCell
            break
        case 16:
            cell = inrCell
            break
        case 17:
            cell = jpyCell
            break
        case 18:
            cell = krwCell
            break
        case 19:
            cell = mxnCell
            break
        case 20:
            cell = myrCell
            break
        case 21:
            cell = nokCell
            break
        case 22:
            cell = nzdCell
            break
        case 23:
            cell = phpCell
            break
        case 24:
            cell = plnCell
            break
        case 25:
            cell = ronCell
            break
        case 26:
            cell = rubCell
            break
        case 27:
            cell = sekCell
            break
        case 28:
            cell = sgdCell
            break
        case 29:
            cell = thbCell
            break
        case 30:
            cell = tryCell
            break
        case 31:
            cell = usdCell
            break
        case 32:
            cell = zarCell
            break
            
        default:
            cell = noneCell
            break
        }
        
        if cell.accessoryType == .checkmark{
            cell.accessoryType = .none
        }
        else{
            cell.accessoryType = .checkmark
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var label = ""
        switch(homeCurrencyChoice!){
        case 1:
            label = "AUD"
            break
        case 2:
            label = "BGN"
            break
        case 3:
            label = "BRL"
            break
        case 4:
            label = "CAD"
            break
        case 5:
            label = "CHF"
            break
        case 6:
            label = "CNY"
            break
        case 7:
            label = "CZK"
            break
        case 8:
            label = "DKK"
            break
        case 9:
            label = "EUR"
            break
        case 10:
            label = "GBP"
            break
        case 11:
            label = "HKD"
            break
        case 12:
            label = "HRK"
            break
        case 13:
            label = "HUF"
            break
        case 14:
            label = "IDR"
            break
        case 15:
            label = "ILS"
            break
        case 16:
            label = "INR"
            break
        case 17:
            label = "JPY"
            break
        case 18:
            label = "KRW"
            break
        case 19:
            label = "MYR"
            break
        case 20:
            label = "MXN"
            break
        case 21:
            label = "NOK"
            break
        case 22:
            label = "NZD"
            break
        case 23:
            label = "PHP"
            break
        case 24:
            label = "PLN"
            break
        case 25:
            label = "RON"
            break
        case 26:
            label = "RUB"
            break
        case 27:
            label = "SEK"
            break
        case 28:
            label = "SGD"
            break
        case 29:
            label = "THB"
            break
        case 30:
            label = "TRY"
            break
        case 31:
            label = "USD"
            break
        case 32:
            label = "ZAR"
            break
            
        default:
            label = "None"
            break
        }
        let count = (navigationController?.viewControllers.count)! - 1
        (navigationController?.viewControllers[count] as! settingsViewController).homeCurrencyChoice.text = label
    }

}
