//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

let vmware = VMWare()

func input(message: String? = "") -> String {
  println("\(message!):")
  var keyboard = NSFileHandle.fileHandleWithStandardInput()
  var inputData = keyboard.availableData
  return NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
}

var generate: [String: AnyObject] {
  get {
    return [
      "feedback": Feedback(),
      "list": vmware.list
    ]
  }
}

func msBuild([String: String] = [String: String]()) {
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
    var pre = input().strip.stripNL
    println("pre: \"\(pre)\"")
    var put = input().strip.stripNL
    println("put: \"\(put)\"")
//  }
}

//let res = shell("echo", "hello", "world")
//println("\(res)")

msBuild()
