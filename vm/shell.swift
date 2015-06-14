//
//  shell.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public
func shell(args: AnyObject...) -> String {
  let task = NSTask()
  let pipe = NSPipe()
  
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.standardOutput = pipe
  task.launch()
  task.waitUntilExit()
  
  let handle = pipe.fileHandleForReading
  let data = handle.readDataToEndOfFile()
  
  if let dataAsString = NSString(data: data, encoding: NSUTF8StringEncoding) {
    return dataAsString as String
  } else {
    return ""
  }
}
