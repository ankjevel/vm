//
//  options.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class Options: Printable {
  
  public var task = "/t:build"
  public var property = "/property:Configuration=Debug"
  public var solution = ""
  public var user = ""
  public var password = ""
}

// MARK: Public
public extension Options {
  
  var description: String {
    get {
      return "{\"task\": \"\(task)\", \"property\": \"\(property)\", \"solution\": \"\(solution)\", \"user\": \"\(user)\", \"password\": \"\(password)\"}";
    }
  }
  
  func update(key: String, value: String? = nil) {
    if value == nil || value == "" {return}

    switch key.lowercaseString {
    case "task": self.task = value!
    case "property": self.property = value!
    case "solution": self.solution = value!
    case "user": self.user = value!
    case "password": self.password = value!
    default: ""
    }
  }
}