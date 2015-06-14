//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

let vmware = VMWare()

var generate: [String: AnyObject] {
  get {
    return [
      "feedback": Feedback(),
      "list": vmware.list
    ]
  }
}

func msBuild([String: String] = [String: String]()) {
  var items = generate["feedback"] as! Feedback
  for vm in generate["list"] as! [VMConfig] {
    if vm.running && vm.os.contains("windows") {
      var item = FeedbackItem(
        title: "Run MSBuild for \(vm.name)",
        id: vm.path,
        argument: "start \"\(vm.path)\""
      )
      items.addItem(item)
    }
  }
  println(items.items[0])
}

//let res = shell("echo", "hello", "world")
//println("\(res)")

msBuild()
