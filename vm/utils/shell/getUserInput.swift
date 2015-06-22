//
//  getUserInput.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func getUserInput(_ message: String = "", noEcho: Bool = false, strip: Bool = true, stripNewLine: Bool = true, stripQuotes: Bool = true) -> String {
  
  var inputString: String
  
  if noEcho {
    inputString = String.fromCString(UnsafePointer<CChar>(getpass("\(message)\n")))!
  } else {
    println("\(message)")
    inputString = NSString(data: NSFileHandle.fileHandleWithStandardInput().availableData, encoding: NSUTF8StringEncoding) as! String
  }
  
  if strip && stripNewLine {
    inputString = inputString.stripWhiteSpaceAndNewLine
  } else if strip {
    inputString = inputString.strip
  } else if stripNewLine {
    inputString = inputString.stripNewLine
  }
  
  if stripQuotes {
    inputString = inputString.removeQuotations
  }
  
  return inputString
}