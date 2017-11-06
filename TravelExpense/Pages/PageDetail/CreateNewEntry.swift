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
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pageObject : Page?
    var catObject : Category?

    override func viewDidLoad() {
        super.viewDidLoad()

        //set up picker views
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(CreateNewEntry.dateChanged), for: .valueChanged)
        date.inputView = datePicker
        
        //set up toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateNewEntry.dismissKeyboard))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spacer, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        date.inputAccessoryView = toolbar
        subLocation.inputAccessoryView = toolbar
        desc.inputAccessoryView = toolbar
        amount.inputAccessoryView = toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done(_ sender: Any) {
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as! Entry

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        let NSdate = dateFormatter.date(from: date.text!) as NSDate?
        entry.dateOf = NSdate
        entry.page?.dateEdited = NSdate
        entry.subLocation = subLocation.text!
        entry.category = catObject!
        entry.desc = desc.text!
        entry.amount = Int32(Float(amount.text!)! * 100)
        entry.page = pageObject
        
        if (catObject?.expense)!{
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categories" {
            let vc = segue.destination as! CategoriesViewController
            vc.categorySelect = true
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func dateChanged(_ sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        let formattedDate = formatter.string(from: sender.date)
        date.text = formattedDate
    }
    
    @IBAction func categoryPressed(_ sender: Any) {
        performSegue(withIdentifier: "categories", sender: self)
    }
    
}
