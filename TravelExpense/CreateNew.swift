//
//  CreateNew.swift
//  
//
//  Created by Thomas Nugent on 26/08/2017.
//
//

import UIKit
import CoreData

class CreateNew: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var localCurrency: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currencies = ["AUD","BGN","BRL","CAD","CHF","CNY","CZK","DKK","EUR","GBP","HKD","HRK","HUF","IDR","ILS","INR","JPY","KRW","MXN","MYR","NOK","NZD","PHP","PLN","RON","RUB","SEK","SGD","THB","TRY","USD","ZAR"]
    var activeCurrency = "EUR"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popup.layer.cornerRadius = 15
        popup.layer.masksToBounds = true
        
        //set up picker views
        let currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        localCurrency.inputView = currencyPicker
        
        //set up toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateNew.dismissKeyboard))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spacer, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        localCurrency.inputAccessoryView = toolbar
        name.inputAccessoryView = toolbar
        name.autocorrectionType = .no
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = currencies[row]
        localCurrency.text = currencies[row]
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OK(_ sender: Any) {
        if name.text != ""{
            let page = NSEntityDescription.insertNewObject(forEntityName: "Page", into: context) as! Page
            let now = Date() as NSDate
            page.dateCreated = now
            page.dateEdited = now
            page.localCurrency = localCurrency.text
            page.location = name.text
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            print("new object created")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
