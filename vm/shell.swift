//
//  shell.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func shell(cmd: AnyObject, args: AnyObject...) -> String {
  let task = NSTask()
  let pipe = NSPipe()
  let errorPipe = NSPipe()
  
  var arguments = [cmd]
  arguments += args
  
  task.launchPath = "/usr/bin/env"
  task.arguments = arguments
  task.standardOutput = pipe
  task.standardError = errorPipe // Just ignore errors
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