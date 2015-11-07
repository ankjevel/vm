//
//  createTask.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-10-30.
//  Copyright © 2015 dennisp.se. All rights reserved.
//

import Foundation

public func createTask(cmd: String, arguments: [String]) -> (String, String) {
  let task = NSTask()
  let pipe = NSPipe()
  let errorPipe = NSPipe()
  
  #if Debug
    print(cmd, arguments)
  #endif
  
  task.launchPath = cmd
  task.arguments = arguments
  task.standardOutput = pipe
  task.standardError = errorPipe
  task.launch()
  task.waitUntilExit()

  let dataAsString = NSString(
    data: pipe.fileHandleForReading.readDataToEndOfFile(),
    encoding: NSUTF8StringEncoding) as? String
  let errorAsString = NSString(
    data: errorPipe.fileHandleForReading.readDataToEndOfFile(),
    encoding: NSUTF8StringEncoding) as? String

  if
    let data = dataAsString as String?,
    let error = errorAsString as String? {

      let hasError = data.hasPrefix("Error:")
      return (
        hasError ? "" : data,
        hasError ? data.stringByReplacingOccurrencesOfString("Error: ", withString: "") : error
      )

  } else if
    let data = dataAsString as String? {
      return (data, "")
  } else if
    let error = errorAsString as String? {
      return ("", error)
  } else {
    return ("", "")
  }
}
