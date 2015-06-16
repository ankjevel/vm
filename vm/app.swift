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

  func msBuild(_ options: Options = Options()) -> FeedbackItem {
    var fb = generate.0
    for vm in generate.1 {
//      if vm.os.contains("windows") {
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
    var selected = getImage(fb, options: options)
    setSolution(&selected)
    setTask(&selected)
    setTaskProperty(&selected)
    setUser(&selected)
    setPassword(&selected)
    
    println("selected: \(selected)")

    return selected
  }
}

// MARK: Private
private extension App {
  
  func getImage(fb: Feedback, options: Options) -> FeedbackItem {
    var index = -1
    let range = fb.items.startIndex ... fb.items.endIndex - 1
    var message = "select image (index):"; for item in enumerate(fb.items) {
      message  += "\n[\(item.index)] \(item.element.title)"
    }
    
    do {
      var input = getUserInput(message)
      if input != "", let unwrapped = input.toInt() {
        index = unwrapped
      }
    } while (range ~= index) == false
    
    var selected = fb.items[index]
    selected.options = options
    
    return selected
  }
  
  func setUser(inout selected: FeedbackItem) {
    while selected.options.user == "" {
      var input = getUserInput("select user:")
      if input != "" {
        selected.options.user = input
      }
    }
  }
  
  func setSolution(inout selected: FeedbackItem) {
    while selected.options.solution == "" && selected.options.solution.lowercaseString.hasSuffix(".sln") == false {
      var input = getUserInput("select solution:")
      if input != "" && input.lowercaseString.hasSuffix(".sln"){
        selected.options.solution = input
      }
    }
  }
  
  func setTask(inout selected: FeedbackItem) {
    while selected.options.task == "" && selected.options.task.hasPrefix("/t:") == false {
      var input = getUserInput("select task:")
      if input != "" && input.lowercaseString.hasPrefix("/t:") {
        selected.options.task = input
      }
    }
  }
  
  func setTaskProperty(inout selected: FeedbackItem) {
    while selected.options.property == "" && selected.options.property.hasPrefix("/property:") == false {
      var input = getUserInput("select task property:")
      if input != "" && input.lowercaseString.hasPrefix("/property:") {
        selected.options.property = input
      }
    }
  }
  
  func setPassword(inout selected: FeedbackItem) {
    while selected.options.password == "" {
      var input = getUserInput("password for \(selected.options.user):", noEcho: true)
      if input != "" {
        selected.options.password = input
      }
    }
  }
  
  var generate: (Feedback, [VMConfig]) {
    get {
      return (Feedback(), vmware.list)
    }
  }
}