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
    let entity: [Setting] = getEntities().filter({$0.id == selected.id})
    var loaded: Bool = false
    
    if entity.count > 0 {
      promptLoad(entity[0], selected: &selected, loaded: &loaded)
    }

    setUser(&selected)
    setPassword(&selected)
    setSolution(&selected)
    setTask(&selected)
    setTaskProperty(&selected)
    
    if loaded == false {
      saveEntity(selected)
    }

    build.run(selected)
  }
}

// MARK: Private
private extension App {
  
  func promptLoad(setting: Setting, inout selected: FeedbackItem, inout loaded: Bool) {
    println("setting: \(setting), selected: \(selected)")
    loaded = true
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
  
  func setUser(inout selected: FeedbackItem) {
    while selected.options.user == "" {
      var input = getUserInput("select user:")
      selected.options.user = input
    }
  }
  
  func setSolution(inout selected: FeedbackItem) {
    let message = "path to solution file (file\(ASCIIColor.Bold.white.rawValue).sln\(ASCIIColor.reset)):"
    while selected.options.solution == "" && selected.options.solution.lowercaseString.hasSuffix(".sln") == false {
      var input = getUserInput(message)
      if input.hasPrefix("~") {
        input = input.stringByExpandingTildeInPath
      }
      selected.options.solution = input
    }
  }
  
  func setTask(inout selected: FeedbackItem) {
    while selected.options.task == "" && selected.options.task.hasPrefix("/t:") == false {
      var input = getUserInput("select msbuild task:")
      selected.options.task = input
    }
  }
  
  func setTaskProperty(inout selected: FeedbackItem) {
    while selected.options.property == "" && selected.options.property.hasPrefix("/property:") == false {
      var input = getUserInput("select msbuild task propert(y|ies):")
      selected.options.property = input
    }
  }
  
  func setPassword(inout selected: FeedbackItem) {
    while selected.options.password == "" {
      var input = getUserInput("password for \(selected.options.user):", noEcho: true)
      selected.options.password = input
    }
  }
  
  var generate: (Feedback, [VMConfig]) {
    get {
      return (Feedback(), vmware.list)
    }
  }
}