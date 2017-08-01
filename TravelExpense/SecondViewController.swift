//
//  SecondViewController.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 29/07/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var finalAmount: UILabel!
    @IBOutlet weak var endCurrency: UITextField!
    @IBOutlet weak var startCurrency: UITextField!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var startCurrencySymbol: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var currencies: [String] = []
    var rates: [Double] = []
    var activeEndCurrency: Double = 0
    var activeStartCurrency: Double = 1
    var lastUpdate: Date?
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load logo
        let image = #imageLiteral(resourceName: "yuppie")
        let imageView = UIImageView(image: image)
        let x = navBar.frame.size.width / 2 - image.size.width / 2
        let y = navBar.frame.size.height / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: x, y: y, width: navBar.frame.size.width, height: navBar.frame.size.height - 5)
        imageView.contentMode = .scaleAspectFit
        navBar.topItem?.titleView = imageView
        
        //set up ads
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        //draw arrow
        let triangle = triangleView(frame: CGRect(x: (self.view.frame.width / 2) - 20 , y: (self.view.frame.height / 2), width: 40, height: 30))
        triangle.backgroundColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.0)
        view.addSubview(triangle)
        
        //Check if there was ever an update and deal with accordingly
        lastUpdate = defaults.object(forKey: "lastUpdate") as? Date
        
        getLatest()
        if lastUpdate == nil {
            getLatest()
        }
        else if let diff = Calendar.current.dateComponents([.hour], from: lastUpdate!, to: Date()).hour, diff > 12 {
            getLatest()
        }
        else{
            currencies = defaults.object(forKey: "currencies") as! [String]
            rates = defaults.object(forKey: "rates") as! [Double]
            activeEndCurrency = rates[0]
        }
        
        //set up picker views
        let startCurrencyPicker = UIPickerView()
        startCurrencyPicker.delegate = self
        startCurrencyPicker.tag = 1
        startCurrency.inputView = startCurrencyPicker
        
        let endCurrencyPicker = UIPickerView()
        endCurrencyPicker.delegate = self
        endCurrencyPicker.tag = 2
        endCurrency.inputView = endCurrencyPicker
        
        //set up toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SecondViewController.dismissKeyboard))
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spacer, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        startCurrency.inputAccessoryView = toolbar
        endCurrency.inputAccessoryView = toolbar
        amount.inputAccessoryView = toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLatest(){
        let url = URL(string: "http://api.fixer.io/latest")
        
        EZLoadingActivity.show("Getting latest rates", disableUI: true)
        
        let task = URLSession.shared.dataTask(with: url!){
            (data, response, error) in
            
            if error != nil {
                EZLoadingActivity.hide(false, animated: true)
                self.userMessage.text = "Cannot get latest data!"
                print("ERROR")
            }
            else{
                if let unwrappedData = data {
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let unwrappedRates = json["rates"] as? NSDictionary{
                            var currenciesUnsorted: [String] = []
                            var ratesUnsorted: [Double] = []
                            
                            for (key, value) in unwrappedRates{
                                currenciesUnsorted.append((key as? String)!)
                                ratesUnsorted.append((value as? Double)!)
                            }
                            
                            currenciesUnsorted.append("EUR")
                            ratesUnsorted.append(1.0)
                            
                            let combined = zip(currenciesUnsorted, ratesUnsorted).sorted { $0.0 < $1.0 }
                            
                            self.currencies = combined.map { $0.0 }
                            self.rates = combined.map { $0.1 }
                            
                        }
                        
                    }
                    catch{
                        EZLoadingActivity.hide(false, animated: true)
                        self.userMessage.text = "Cannot get latest data!"
                    }
                    
                }
            }
            
            DispatchQueue.main.sync(execute: { 
                self.defaults.set(self.rates, forKey: "rates")
                self.defaults.set(self.currencies, forKey: "currencies")
                self.activeEndCurrency = self.rates[0]
                
                self.lastUpdate = Date()
                self.defaults.set(self.lastUpdate, forKey: "lastUpdate")
                
                let formattedDate = DateFormatter()
                formattedDate.dateFormat = "dd/MM/yy' at 'h:mm a zzzz."
                let msg = "Last Updated: " + formattedDate.string(from: self.lastUpdate!)
                self.userMessage.text = msg
                
                EZLoadingActivity.hide(true, animated: true)
            })
        }
        
        task.resume()
        
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
        if pickerView.tag == 1 {
            activeStartCurrency = rates[row]
            startCurrency.text = currencies[row]
        }
        else if pickerView.tag == 2 {
            activeEndCurrency = rates[row]
            endCurrency.text = currencies[row]
        }
        
        updateConversion()
    }

    @IBAction func amountChanged(_ sender: Any) {
        updateConversion()
    }
    
    func updateConversion(){
        let startSymbol = currencySymbol(code: startCurrency.text!)
        startCurrencySymbol.text = startSymbol
        let endSymbol = currencySymbol(code: endCurrency.text!)
        
        if amount.text != ""{
            let value = round(Double(amount.text!)! * (activeEndCurrency/activeStartCurrency) * 100) / 100
            
            finalAmount.text = endSymbol + String(value)
        }
        else{
            finalAmount.text = endSymbol + "0.00"
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func currencySymbol(code: String) -> String {
        switch(code){
        case "AUD":
            return "$ "
        case "BGN":
            return "лв "
        case "BRL":
            return "R$ "
        case "CAD":
            return "$ "
        case "CHF":
            return "CHF "
        case "CNY":
            return "¥ "
        case "CZK":
            return "Kč "
        case "DKK":
            return "kr "
        case "EUR":
            return "€ "
        case "GBP":
            return "£ "
        case "HKD":
            return "$ "
        case "HRK":
            return "kn "
        case "HUF":
            return "Ft "
        case "IDR":
            return "Rp "
        case "ILS":
            return "₪ "
        case "INR":
            return "₹ "
        case "JPY":
            return "¥ "
        case "KRW":
            return "₩ "
        case "MXN":
            return "$ "
        case "MYR":
            return "RM "
        case "NOK":
            return "kr "
        case "NZD":
            return "$ "
        case "PHP":
            return "₱ "
        case "PLN":
            return "zł "
        case "RON":
            return "lei "
        case "RUB":
            return "₽ "
        case "SEK":
            return "kr "
        case "SGD":
            return "$ "
        case "THB":
            return "฿ "
        case "TRY":
            return "₺ "
        case "USD":
            return "$ "
        case "ZAR":
            return "R "
            
        default:
            return ""
        }
    }
}
