//
//  CreateNewEntry.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 16/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit
import CoreData

class CreateNewEntry: UITableViewController {
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var subLocation: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var expense: UISwitch!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pageObject : Page?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done(_ sender: Any) {
        print("done")
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as! Entry

        entry.dateOf = Date() as NSDate
        entry.subLocation = subLocation.text!
        entry.category = category.text!
        entry.desc = desc.text!
        entry.expense = expense.isOn
        entry.amount = Int32(Float(amount.text!)! * 100)
        entry.page = pageObject
        
        if expense.isOn{
            entry.page?.total -= entry.amount
        }
        else{
            entry.page?.total += entry.amount
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        navigationController?.popViewController(animated: true)
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
