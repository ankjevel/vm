//
//  getUserInput.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func getUserInput(_ message: String = "", strip: Bool = true, stripNewLine: Bool = true) -> String {
  
  if message != "" {
    println("\(message)")
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