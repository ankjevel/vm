//
//  app.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-15.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class App: CoreData {

  private var vmware = VMWare()
  private let keychain = Keychain()
  private let build: MSBuild
  
  override init() {
    self.build = MSBuild(vmware: &self.vmware)
    super.init()
  }
}

// MARK: Public
public extension App {

  func msBuild(_ options: Options = Options()) {
    var fb = generate.0
    for vm in generate.1 {
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
    if entityExists {
      promptLoad(entity.last!, selected: &selected, loaded: &loaded)
    }

    setUser(&selected, loaded: &loaded)
    setPassword(&selected, loaded: &loaded)
    setSolution(&selected, loaded: &loaded)
    setTask(&selected, loaded: &loaded)
    setTaskProperty(&selected, loaded: &loaded)
    
    if loaded == false {
      saveEntity(selected, update: entityExists)
    }

    build.run(selected)
  }
}

// MARK: Private
private extension App {
  func setUserAndPassword(user: String, inout selected: FeedbackItem) {
    if var password = keychain.load(user) as String? {
      selected.options.password = password
    }
    selected.options.user = user
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
      if setting.user != "" && selected.options.user == "", let unwrapped = setting.user {
        user = unwrapped
      } else if selected.options.user != "" {
        user = selected.options.user
      }
      if let unwrapped = user {
        setUserAndPassword(unwrapped, selected: &selected)
      }
      selected.options.solution = setting.solution!
      selected.options.task = setting.task!
      selected.options.property = setting.property!
      loaded = true
    }
  }
  
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
  
  func setUser(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.user == "" {
      var input = getUserInput("select user:")
      selected.options.user = input
      loaded = false
    }
  }
  
  func setSolution(inout selected: FeedbackItem, inout loaded: Bool) {

    let message = "path to solution file (file\(ASCIIColor.Bold.white.rawValue).sln\(ASCIIColor.reset)):"
    while selected.options.solution == "" && selected.options.solution.lowercaseString.hasSuffix(".sln") == false {
      var input = getUserInput(message)
      if input.hasPrefix("~") {
        input = input.stringByExpandingTildeInPath
      }
      selected.options.solution = input
      loaded = false
    }
  }
  
  func setTask(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.task == "" && selected.options.task.hasPrefix("/t:") == false {
      var input = getUserInput("select msbuild task:")
      selected.options.task = input
      loaded = false
    }
  }
  
  func setTaskProperty(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.property == "" && selected.options.property.hasPrefix("/property:") == false {
      var input = getUserInput("select msbuild task propert(y|ies):")
      selected.options.property = input
      loaded = false
    }
  }
  
  func setPassword(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.password == "" {
      var input = getUserInput("password for \(selected.options.user):", noEcho: true)
      selected.options.password = input
      loaded = false
    }
    savePassword(selected.options)
  }
  
  func savePassword(options: Options) {
    keychain.save(options.user, data: options.password)
  }
  
  var generate: (Feedback, [VMConfig]) {
    get {
      return (Feedback(), vmware.list)
    }
  }
}