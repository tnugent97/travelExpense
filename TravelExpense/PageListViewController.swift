//
//  PageListViewController.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 13/09/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit
import CoreData

class PageListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<Page>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navBar set up
        let imageView = UIImageView(image: #imageLiteral(resourceName: "yuppie"))
        imageView.frame = CGRect(x: 0, y: 0, width: (navigationController?.navigationBar.frame.size.width)! / 2, height: (navigationController?.navigationBar.frame.size.height)! - 5)
        imageView.contentMode = .scaleAspectFit
        navigationController?.navigationBar.topItem?.titleView = imageView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newCategory))
        navigationItem.leftBarButtonItem = self.editButtonItem
        
        //table view set up
        tableView.register(UINib(nibName: "customPageCell", bundle: nil), forCellReuseIdentifier: "customPageCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        tableView.backgroundView = Bundle.main.loadNibNamed("EmptyTableView", owner: self, options: nil)?.first as? EmptyTableView
        
        //fetched results controller set up
        let request: NSFetchRequest<Page> = Page.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        fetchedResultsController = NSFetchedResultsController<Page>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
        if segue.identifier == "pageDetail" {
            segue.destination.title = (sender as! String)
        }
    }
    
    
    //MARK: custom functions
    func newCategory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alert = storyboard.instantiateViewController(withIdentifier: "createNew")
        alert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Table view functions
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPageCell", for: indexPath) as! customPageCell
        
        if let obj = fetchedResultsController?.object(at: indexPath){
            cell.title.text = obj.location
            cell.localCurrency.text = obj.localCurrency
            
            let formattedDate = DateFormatter()
            formattedDate.dateFormat = "dd/MM/yy' at 'H:mm zzz."
            cell.dateCreated.text = formattedDate.string(from: obj.dateCreated! as Date)
            cell.lastEdited.text = formattedDate.string(from: obj.dateEdited! as Date)
            cell.accessoryType = .disclosureIndicator
        }
        else{
            print("error loading table cell")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: prepare for segue and then do it
        let cell = tableView.cellForRow(at: indexPath) as! customPageCell
        performSegue(withIdentifier: "pageDetail", sender: cell.title.text)
    }
    
    
    // MARK: Fetched results controller delegate functions
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
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

//MARK

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

