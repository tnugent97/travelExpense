//
//  CreateNewCategory.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 28/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit
import CoreData

class CreateNewCategory: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var expense: UISwitch!
    @IBOutlet weak var popup: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popup.layer.cornerRadius = 15
        popup.layer.masksToBounds = true
        
        //set up toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateNewCategory.dismissKeyboard))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spacer, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        name.inputAccessoryView = toolbar
        name.autocorrectionType = .no
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func OK(_ sender: Any) {
        if name.text != ""{
            let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
            
            category.name = name.text!
            category.expense = expense.isOn
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            print("new object created")
            self.dismiss(animated: true, completion: nil)
        }
        else{
            name.layer.borderColor = UIColor.red.cgColor
            name.layer.borderWidth = 1
            name.layer.cornerRadius = 5
        }
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
