//
//  PageViewController.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 13/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit
import CoreData

class PageDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var total: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<Entry>?
    
    var pageObject : Page?

    override func viewDidLoad() {
        super.viewDidLoad()

        //navbar set up
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newEntry))
        
        //tableView setup
        tableView.register(UINib(nibName: "customPageDetailCell", bundle: nil), forCellReuseIdentifier: "customPageDetailCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.separatorStyle = .none
        total.text = String(Double((pageObject?.total)!) / 100.0)
        tableView.backgroundView = Bundle.main.loadNibNamed("EmptyPageDetailView", owner: self, options: nil)?.first as? EmptyPageDetailView
        
        //fetched results controller set up
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateOf", ascending: true)]
        request.predicate = NSPredicate(format: "page.location = %@", self.title!)
        
        fetchedResultsController = NSFetchedResultsController<Entry>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewEntry" {
            (segue.destination as! CreateNewEntry).pageObject = (sender as! Page)
        }
    }
    
    //MARK: custom functions
    func newEntry(){
        performSegue(withIdentifier: "createNewEntry", sender: pageObject)
    }
    
    @IBAction func showCategories(_ sender: Any) {
        performSegue(withIdentifier: "showCategories", sender: nil)
    }
    
    //MARK: Table view functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            //check the user really wants to delete
            let alert = UIAlertController(title: "Are you sure?", message: "This cannot be undone!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                if let obj = self.fetchedResultsController?.object(at: indexPath){
                    self.context.delete(obj)
                    
                    do {
                        try self.context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            let num = sections[section].numberOfObjects
            
            //show empty background view
            if num == 0 {
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
            }
            else{
                tableView.separatorStyle = .singleLine
                tableView.backgroundView?.isHidden = true
            }
            return num
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPageDetailCell", for: indexPath) as! customPageDetailCell
        
        if let obj = fetchedResultsController?.object(at: indexPath){
            cell.location.text = obj.subLocation
            cell.category.text = obj.category?.name
            cell.desc.text = obj.desc
            
            let amount = Float(obj.amount) / 100
            let numberFormatter = NumberFormatter()
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.numberStyle = NumberFormatter.Style.currency
            let finalAmount = numberFormatter.string(from: amount as NSNumber)?.replacingOccurrences(of: "$", with: "")
            
            if obj.category?.expense == true {
                cell.amount.text = "-" + finalAmount!
                cell.amount.textColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
            }
            else{
                cell.amount.text = finalAmount!
                cell.amount.textColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
            }
            cell.amount.adjustsFontSizeToFitWidth = true
            
            let formattedDate = DateFormatter()
            formattedDate.dateFormat = "dd/MM/yy"
            cell.date.text = formattedDate.string(from: obj.dateOf! as Date)
            
        }
        else{
            print("error loading table cell")
        }
        return cell
    }
    
    // MARK: Fetched results controller delegate functions
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        total.text = String(Double((pageObject?.total)!) / 100.0)
        tableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType){
        switch type {
        case .insert: tableView.insertSections([sectionIndex], with: .fade)
        case .delete: tableView.deleteSections([sectionIndex], with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        tableView.endUpdates()
    }

}
