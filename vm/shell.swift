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


public func repeat(value: String, repeateCount: Int) -> String {
  return "".join(Array(count: repeateCount, repeatedValue: value))
}

public func center(str: String) -> String {
  let odd = (WIDTH - count(str)) % 2 == 1
  let padding = (WIDTH - count(str)) / 2
  
  func print(_ last: Bool = false) -> String {
    return repeat(" ", last && odd ? padding + 1 : padding)
  }
  
  return print() + str + print(true)
}

public func header(str: String) -> [String] {
  let r = ASCIIColor.reset.rawValue
  let bbgb = r + ASCIIColor.white.rawValue + ASCIIColor.Background.blue.rawValue
  
  return [
    "",
    "\(bbgb)" + repeat(" ", WIDTH) + "\(r)",
    "\(bbgb)" + center("\(str)") + "\(r)",
    "\(bbgb)" + repeat(" ", WIDTH) + "\(r)",
    ""
  ]
}