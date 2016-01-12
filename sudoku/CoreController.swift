//
//  CoreController.swift
//  Sudoku
//
//  Created by slee on 2016/1/7.
//  Copyright © 2016年 slee. All rights reserved.
//


import CoreData

class CoreController: NSObject {
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
          //  var path : NSSearchPathDirectory = .CachesDirectory + "/" + NSBundle.mainBundle().bundleIdentifier
            
            
            let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
            let cacheURL = urls[urls.endIndex-1]
            let appcacheURL = cacheURL.URLByAppendingPathComponent( NSBundle.mainBundle().bundleIdentifier!,isDirectory: true)

            
            
    

            
            let storeURL = appcacheURL.URLByAppendingPathComponent( "SudokuModel.sqlite")
      
            
            
            
            do{
                try  NSFileManager.defaultManager().createDirectoryAtURL(appcacheURL, withIntermediateDirectories: false, attributes: nil)
                
            }catch{
              //  fatalError("Error build directory: \(error)")

            }
            
            
           
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            }
            
            catch {
                do{
              
                try NSFileManager.defaultManager().removeItemAtURL(appcacheURL)
                try  NSFileManager.defaultManager().createDirectoryAtURL(appcacheURL, withIntermediateDirectories: false, attributes: nil)
                    do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
                    }catch{
                        fatalError("Error migrating store: \(error)")
                    }
                
                }catch {
                    fatalError("Error delete and rebuild store: \(error)")
                }
            }
        }
    }
}