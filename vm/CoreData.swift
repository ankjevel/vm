//
//  CoreData.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-20.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import CoreData

public class CoreData {
  
  private let entityName: String = "Setting"

  lazy var applicationDocumentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1] as! NSURL
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource("VMS", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("vm.sqlite")
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true], error: &error) == nil {
      coordinator = nil
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      dict[NSUnderlyingErrorKey] = error
      
      halt(dict)
    }
    
    return coordinator
    }()
  
  lazy var managedObjectContext: NSManagedObjectContext? = {
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext()
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
  func getEntities() -> [Setting] {
    
    let fetchRequest = NSFetchRequest(entityName: entityName)
    let results: [Setting]
    
    if let context = managedObjectContext,
      let fetchedResults = context.executeFetchRequest(fetchRequest, error: nil) {
        results = fetchedResults as! [Setting]
    } else {
      results = []
    }
    println(results.count)
    return results
  }
  
  func saveEntity(fb: FeedbackItem, update: Bool) {
    
    if let context = managedObjectContext,
      let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context),
      let setting = NSManagedObject(entity: entity as NSEntityDescription, insertIntoManagedObjectContext: context) as? Setting {
        setting.setValue(fb.id, forKey: "id")
        setting.setValue(fb.options.property, forKey: "property")
        setting.setValue(fb.options.solution, forKey: "solution")
        setting.setValue(fb.options.task, forKey: "task")
        setting.setValue(fb.options.user, forKey: "user")
        saveContext(update)
    }
  }
}

private extension CoreData {
  func saveContext(update: Bool) {
    if let moc = self.managedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges {
        if update == false {
          if !moc.save(&error) {
            halt(error!)
          } else {
            moc.updatedObjects
          }
        }
      }
    }
  }
}