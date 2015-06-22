//
//  app.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-15.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import CoreData

public class App: CoreData {

  private var vmware = VMWare()
  private let keychain = Keychain()
  private let build: MSBuild
  
  override init() {
    self.build = MSBuild(vmware: &self.vmware)
    super.init()
    
    checkIfClearCoreData()
  }
}

// MARK: Public
public extension App {

  func msBuild(_ options: MSBuildOptions = MSBuildOptions()) {
    var gen = generate
    var fb = gen.0
    for vm in gen.1 {
//      if vm.os.contains("windows") {
      if vm.running && vm.os.contains("windows") {
        var item = FeedbackItem(
          title: vm.name,
          id: vm.path
        )
        fb.addItem(item)
      }
    }
    
    if fb.items.count == 0 {
      halt("no vms running")
    }
    
    //  if fb.items.count > 1 {
    var selected = getImage(fb, options: options)
    keychain.identifier = selected.id
    
    let entity: [Setting] = getEntities().filter({
      $0.id as Any? != nil &&
      $0.property as Any? != nil &&
      $0.solution as Any? != nil &&
      $0.task as Any? != nil &&
      $0.user as Any? != nil &&
      $0.id == selected.id
    })
    var loaded: Bool = false
    let entityExists = entity.count > 0
    
    if entityExists, let last = entity.last {
      promptLoad(last, selected: &selected, loaded: &loaded)
    }

    setUser(&selected, loaded: &loaded)
    setPassword(&selected, loaded: &loaded)
    setSolution(&selected, loaded: &loaded)
    setTask(&selected, loaded: &loaded)
    setTaskProperty(&selected, loaded: &loaded)
    
    if loaded == false {
      saveEntity(selected, update: entityExists)
    }
    
    build.selected = selected
    build.run()
  }
}

// MARK: Private
private extension App {
  
  func setUserAndPassword(user: String, inout selected: FeedbackItem) {
    if var password = keychain.load(user) as String? {
      selected.options.password.value = password
    }
    selected.options.user.value = user
  }
  
  func promptLoad(setting: Setting, inout selected: FeedbackItem, inout loaded: Bool) {
    var loadProfile: Bool? = nil
    
    if selected.options.forceYes {
      loadProfile = true
    }
    
    while loadProfile == nil {
      var input = getUserInput("load user profile (yes|no)?")
      if input != "" {
        loadProfile = input.bool
      }
    }

    if loadProfile == true {
      var user: String? = nil
      
      if selected.options.user.set {
        user = selected.options.user.value
      } else if setting.user != "" {
        user = setting.user
      }
      
      if let unwrapped = user {
        setUserAndPassword(unwrapped, selected: &selected)
      }
      if selected.options.solution.set == false {
        selected.options.solution.value = setting.solution!
      }
      if selected.options.task.set == false {
        selected.options.task.value = setting.task!
      }
      if selected.options.property.set == false {
        selected.options.property.value = setting.property!
      }
      loaded = true
    }
  }
  
  func getImage(fb: Feedback, options: MSBuildOptions) -> FeedbackItem {
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
  
  func setUser(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.user.set == false {
      var input = getUserInput("select user:")
      selected.options.user.value = input
      loaded = false
    }
  }
  
  func setSolution(inout selected: FeedbackItem, inout loaded: Bool) {

    let message = "path to solution file (file\(ASCIIColor.Bold.white).sln\(ASCIIColor.reset)):"
    while selected.options.solution.set == false {
      var input = getUserInput(message)
      if input.hasPrefix("~") {
        input = input.stringByExpandingTildeInPath
      }
      selected.options.solution.value = input
      loaded = false
    }
  }
  
  func setTask(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.task.set == false {
      var input = getUserInput("select msbuild task:")
      selected.options.task.value = input
      loaded = false
    }
  }
  
  func setTaskProperty(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.property.set == false {
      var input = getUserInput("select msbuild task propert(y|ies):")
      selected.options.property.value = input
      loaded = false
    }
  }
  
  func setPassword(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.password.set == false {
      var input = getUserInput("password for \(selected.options.user):", noEcho: true)
      selected.options.password.value = input
      loaded = false
    }
    savePassword(selected.options)
  }
  
  func savePassword(options: MSBuildOptions) {
    keychain.save(options.user.value, data: options.password.value)
  }
  
  func checkIfClearCoreData() {
    var clear = false
    eachProcessArgument({ argument in
      if argument == "c" || argument == "clear" {
        clear = true
      }
    })
    
    if clear {
      var userInput: Bool? = nil
      
      while userInput == nil {
        var input = getUserInput("do you really want to clear Core Data?")
        if input != "" {
          userInput = input.bool
        }
      }
      
      var entities = getEntities()
      
      if let context = managedObjectContext {
        for entity: NSManagedObject in entities {
          context.deleteObject(entity)
        }
      }
      
      entities.removeAll(keepCapacity: false)
      
      saveContext(false)
    }
  }
  
  var generate: (Feedback, [VMConfig]) {
    get {
      return (Feedback(), vmware.list)
    }
  }
}