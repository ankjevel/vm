//
//  options.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class Options: Printable {

  private var _task = ("/t:build", false)
  private var _property = ("/property:Configuration=Debug", false)
  private var _solution = ("", false)
  
  public var task: String {
    get { return _task.0 }
    set (value) {
      if value == "" || value.hasPrefix("/t:") {
        _task.0 = value
        _task.1 = true
      } else {
        println("\(ASCIIColor.Bold.red.rawValue)invalid value for task: \(value)\(ASCIIColor.reset)")
      }
    }
  }
  
  public var property: String {
    get { return _property.0 }
    set (value) {
      if value == "" || value.hasPrefix("/property:") {
        _property.0 = value
        _property.1 = true
      } else {
        println("\(ASCIIColor.Bold.red.rawValue)invalid value for property: \(value)\(ASCIIColor.reset)")
      }
    }
  }
  
  public var solution: String {
    get { return _solution.0 }
    set (value) {
      if value.hasSuffix(".sln") && value.instancesOf("\\\\") > 1 {
        _solution.0 = value
        _solution.1 = true
      } else {
        println("\(ASCIIColor.Bold.red.rawValue)invalid value for solution: \(value)\(ASCIIColor.reset)")
      }
    }
  }
  
  public var user = ""
  public var password = ""
  public var forceYes: Bool = false
  
  public var taskSet: Bool {
    get { return _task.1 }
  }
  
  public var propertySet: Bool {
    get { return _property.1 }
  }
  
  public var solutionSet: Bool {
    get { return _solution.1 }
  }
}

// MARK: Private
private extension Options {}

// MARK: Public
public extension Options {
  
  var description: String {
    get {
      return "{" +
        "\"task\": \"\(task)\", " +
        "\"property\": \"\(property)\", " +
        "\"solution\": \"\(solution)\", " +
        "\"user\": \"\(user)\", " +
        "\"password\": \"\(password)\", " +
        "\"forceYes\": \"\(forceYes)\", " +
        "\"set values\": [" +
          "{\"taskSet\": \"\(taskSet)\"}, " +
          "{\"propertySet\": \"\(propertySet)\"}, " +
          "{\"solutionSet\": \"\(solutionSet)\"}" +
        "]" +
      "}";
    }
  }
  
  func update(key: String, value: String? = nil) {
    if value == nil || value == "" {return}

    switch key.lowercaseString {
    case "task", "t": self.task = value!
    case "property", "o": self.property = value!
    case "solution", "s": self.solution = value!
    case "user", "u": self.user = value!
    case "password", "p": self.password = value!
    case "y": self.forceYes = value!.bool
    default: ""
    }
  }
}