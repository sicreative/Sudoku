//
//  Sudoku_table+CoreDataProperties.swift
//  Sudoku
//
//  Created by slee on 2016/1/8.
//  Copyright © 2016年 slee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Sudoku_table {

    @NSManaged var table: Date?
    @NSManaged var card: NSSet?
    @NSManaged var level: NSNumber?

}
