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
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        DispatchQueue.global(qos:.background).async {
          //  var path : NSSearchPathDirectory = .CachesDirectory + "/" + NSBundle.mainBundle().bundleIdentifier
            
            
            let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            let cacheURL = urls[urls.endIndex-1]
            let appcacheURL = cacheURL.appendingPathComponent( Bundle.main.bundleIdentifier!,isDirectory: true)

            
            
    

            
            let storeURL = appcacheURL.appendingPathComponent( "Cache.db")
      
            
            
            
            do{
                try  FileManager.default.createDirectory(at: appcacheURL, withIntermediateDirectories: false, attributes: nil)
                
            }catch{
              //  fatalError("Error build directory: \(error)")

            }
            
            
           
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            }
            
            catch {
                do{
              
                try FileManager.default.removeItem(at: appcacheURL)
                try  FileManager.default.createDirectory(at: appcacheURL, withIntermediateDirectories: false, attributes: nil)
                    do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
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
