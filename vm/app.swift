//
//  app.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-15.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import CoreData

public class App {

  private let vmware = VMWare()
  
  // MARK: - Core Data stack
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
  
  // MARK: - Core Data Saving support
  func saveContext () {
    if let moc = self.managedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges && !moc.save(&error) {
        halt(error!)
      }
    }
  }
}

// MARK: Public
public extension App {

  func msBuild(_ options: Options = Options()) -> Feedback {
    var fb = generate.0
    for vm in generate.1 {
      // if vm.os.contains("windows") {
      if vm.running && vm.os.contains("windows") {
        var item = FeedbackItem(
          title: vm.name,
          id: vm.path,
          argument: "start \"\(vm.path)\""
        )
        fb.addItem(item)
      }
    }
    
    if fb.items.count == 0 {
      halt("no vms running")
    }
    
    //  if fb.items.count > 1 {
    var index = -1
    let range = fb.items.startIndex ... fb.items.endIndex - 1
    var message = "select image:\n"
    for item in enumerate(fb.items) {
      message += "\n(\(item.index)) \(item.element.title)"
    }
    
    do {
      var input = getUserInput(message)
      if input != "", let unwrapped = input.toInt() {
        index = unwrapped
      }
    } while (range ~= index) == false
    
    fb.items[index].options = options
    
    let managedObjectContext = self.managedObjectContext
    
    println(managedObjectContext!)
    
    println("selected: \(fb.items[index])")
    //  }
    
    return fb
  }
}

// MARK: Private
private extension App {
  
  var generate: (Feedback, [VMConfig]) {
    get {
      return (Feedback(), vmware.list)
    }
  }
}