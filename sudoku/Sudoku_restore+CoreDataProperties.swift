//
//  Sudoku_restore+CoreDataProperties.swift
//  Sudoku
//
//  Created by slee on 2016/1/17.
//  Copyright © 2016年 slee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Sudoku_restore {

    @NSManaged var editable: NSNumber?
    @NSManaged var num: NSNumber?
    @NSManaged var pos: NSNumber?
    @NSManaged var fillednum: NSNumber?

}
