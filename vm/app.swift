//
//  app.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-15.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import Darwin

public class App {

  private let vmware = VMWare()
}

// MARK: Public
public extension App {

  func msBuild(_ options: [String: String] = [String: String]()) -> Feedback {
    var fb = generate.0
    for vm in generate.1 {
      if vm.running && vm.os.contains("windows") {
        //    if vm.os.contains("windows") {
        var item = FeedbackItem(
          title: vm.name,
          id: vm.path,
          argument: "start \"\(vm.path)\""
        )
        fb.addItem(item)
      }
    }
    if fb.items.count == 0 {
      println("no vms running")
      exit(0)
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