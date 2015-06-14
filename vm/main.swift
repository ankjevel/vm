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
    println("\(message!):")
  }
  
  var keyboard = NSFileHandle.fileHandleWithStandardInput()
  var inputData = keyboard.availableData
  var inputString = NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
  
  if strip == true {
    inputString = inputString.strip
  }
  
  if stripNewLine == true {
    inputString = inputString.stripNL
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
//    if vm.running && vm.os.contains("windows") {
    if vm.os.contains("windows") {
      var item = FeedbackItem(
        title: vm.name,
        id: vm.path,
        argument: "start \"\(vm.path)\""
      )
      fb.addItem(item)
    }
  }
//  if fb.items.count > 1 {
  
//  } else {
    var pre = getUserInput("pre")
    println("pre: \"\(pre)\"")
    var put = getUserInput("post")
    println("put: \"\(put)\"")
//  }
}

//let res = shell("echo", "hello", "world")
//println("\(res)")

msBuild()
