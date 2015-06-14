//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

let vmware = VMWare()

func getUserInput(_ message: String? = "", strip: Bool? = true, stripNewLine: Bool? = true) -> String {
  
  if message != "" {
    println("\(message!)")
  }
  
  var keyboard = NSFileHandle.fileHandleWithStandardInput()
  var inputData = keyboard.availableData
  var inputString = NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
  
  if strip == true {
    inputString = inputString.strip
  }
  
  if stripNewLine == true {
    inputString = inputString.stripNewLine
  }
  
  return inputString
}

var generate: [String: AnyObject] {
  get {
    return [
      "feedback": Feedback(),
      "list": vmware.list
    ]
  }
}

func msBuild(_ options: [String: String] = [String: String]()) {
  var fb = generate["feedback"] as! Feedback
  for vm in generate["list"] as! [VMConfig] {
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
}

msBuild()
