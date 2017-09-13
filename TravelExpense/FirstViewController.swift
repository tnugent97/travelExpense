//
//  FirstViewController.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 29/07/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<Page>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navBar image
        let image = #imageLiteral(resourceName: "yuppie")
        let imageView = UIImageView(image: image)
        let x = (navigationController?.navigationBar.frame.size.width)! / 2 - image.size.width / 2
        let y = (navigationController?.navigationBar.frame.size.height)! / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: x, y: y, width: (navigationController?.navigationBar.frame.size.width)!, height: (navigationController?.navigationBar.frame.size.height)! - 5)
        imageView.contentMode = .scaleAspectFit
        navigationController?.navigationBar.topItem?.titleView = imageView
        
        //table view set up
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "customCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
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
    
    
    //MARK: Table view delegate functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            if let obj = fetchedResultsController?.object(at: indexPath){
                context.delete(obj)
                do {
                    try context.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! customCell
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: prepare for segue and then do it
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

    //MARK: IBActions
    @IBAction func newCategory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alert = storyboard.instantiateViewController(withIdentifier: "createNew")
        alert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alert, animated: true, completion: nil)
    }

}

