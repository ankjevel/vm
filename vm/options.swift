//
//  options.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class Options: Printable {

  public var user = MSBuildOption("", "user", { (value: String) -> Bool in
    return value != ""
  })
  
  public var password = MSBuildOption("", "password", { (value: String) -> Bool in
    return value != ""
  })
  
  public var solution = MSBuildOption("", "solution", { (value: String) -> Bool in
    return value.hasSuffix(".sln") && value.instancesOf("\\\\") > 1
  })
  
  public var property = MSBuildOption("", "property", { (value: String) -> Bool in
    return value == "" || value.hasPrefix("/property:")
  })
  
  public var task = MSBuildOption("", "task", { (value: String) -> Bool in
    return value == "" || value.hasPrefix("/t:")
  })

  public var forceYes: Bool = false
}

// MARK: Private
private extension Options {}

// MARK: Public
public extension Options {
  
  var description: String {
    get {
      return "{" +
        "\"task\": \"\(task.value)\", " +
        "\"property\": \"\(property.value)\", " +
        "\"solution\": \"\(solution.value)\", " +
        "\"user\": \"\(user.value)\", " +
        "\"password\": \"\(password.value)\", " +
        "\"forceYes\": \"\(forceYes)\", " +
        "\"set values\": [" +
          "{\"taskSet\": \"\(task.set)\"}, " +
          "{\"propertySet\": \"\(property.set)\"}, " +
          "{\"solutionSet\": \"\(solution.set)\"}" +
        "]" +
      "}";
    }
  }
  
  func update(key: String, value: String? = nil) {
    if value == nil || value == "" {return}

    switch key.lowercaseString {
    case "task", "t": self.task.value = value!
    case "property", "o": self.property.value = value!
    case "solution", "s": self.solution.value = value!
    case "user", "u": self.user.value = value!
    case "password", "p": self.password.value = value!
    case "y": self.forceYes = value!.bool
    default: ""
    }
  }
}