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

public func halt(message: String) {
  
  var dict = [String: AnyObject]()
  dict[NSLocalizedDescriptionKey] = message
  
  halt(dict)
}

public func halt(dict: [String: AnyObject]) {
  
  var error = NSError(domain: "VM", code: 9999, userInfo: dict)
  
  halt(error)
}

public func halt(error: NSError) {
  
  NSLog("Unresolved error \(error), \(error.userInfo!)")
  
  abort()
}