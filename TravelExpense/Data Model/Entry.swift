//
//  Entry.swift
//  TravelExpense
//
//  Created by Thomas Nugent on 30/08/2017.
//  Copyright © 2017 Thomas Nugent. All rights reserved.
//

import UIKit
import CoreData

class Entry: NSManagedObject {
    
    override func prepareForDeletion() {
        if category?.expense == true {
            page?.total += amount
        }
        else{
            page?.total -= amount
        }
        
        page?.dateEdited = Date() as NSDate
    }
}
