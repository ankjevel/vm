//
//  shell.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

internal func createTask(arguments: [String]) -> (String, String) {
  let task = NSTask()
  let pipe = NSPipe()
  let errorPipe = NSPipe()
  
  task.launchPath = "/usr/bin/env"
  task.arguments = arguments
  task.standardOutput = pipe
  task.standardError = errorPipe
  task.launch()
  task.waitUntilExit()
  
  var dataAsString = NSString(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: NSUTF8StringEncoding) as? String
  var errorAsString = NSString(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: NSUTF8StringEncoding) as? String
  
  if
    var data = dataAsString as String?,
    var error = errorAsString as String? {
  
      let hasError = data.hasPrefix("Error:")
      return (
        hasError ? "" : data,
        hasError ? data.stringByReplacingOccurrencesOfString("Error: ", withString: "") : error
      )
  } else if
    var data = dataAsString as String? {
    return (data, "")
  } else if
    var error = errorAsString as String? {
    return ("", error)
  } else {
    return ("", "")
  }
}

public func shell(cmd: String, args: String...) -> String {
  var arguments = [cmd]
  arguments += args
  
  var (response, _) = createTask(arguments)
  
  return response
}

public func shell(cmd: String, printError: Bool, args: String...) -> (String, String) {
  var arguments = [cmd]
  arguments += args
  
  var (response, errorResponse) = createTask(arguments)
  println("response: \(response)\nerrorResponse: \(errorResponse)")
  return (response, errorResponse)
}