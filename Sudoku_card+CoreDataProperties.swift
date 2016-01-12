//
//  Sudoku_card+CoreDataProperties.swift
//  Sudoku
//
//  Created by slee on 2016/1/9.
//  Copyright © 2016年 slee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Sudoku_card {

    @NSManaged var num: NSNumber?
    @NSManaged var pos: NSNumber?
    @NSManaged var editable: NSNumber?
    @NSManaged var table: Sudoku_table?

}
