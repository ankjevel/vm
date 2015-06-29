//
//  halt.swift
//  vm
//
//  Hammerzeit
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import Darwin

public func halt(message: String, _ code: Int = 0, _ vm: String = "") {
  var dict = [String: AnyObject]()
  dict[NSLocalizedDescriptionKey] = message
  if vm != "" {
    dict[NSLocaleIdentifier] = vm
  }
  
  halt(dict, code)
}

public func halt(dict: [String: AnyObject], _ code: Int = 0) {
  var error = NSError(domain: "VM", code: code, userInfo: dict)
  
  halt(error)
}

public func halt(error: NSError) {
  NSLog("Unresolved error \(error), \(error.userInfo!)")
  
  abort()
}