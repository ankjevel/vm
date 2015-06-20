//
//  options.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class Options: Printable {
  private var _task = "/t:build"
  private var _property = "/property:Configuration=Debug"
  private var _solution = ""
  
  public var task: String {
    get { return _task }
    set (value) {
      if value == "" || value.hasPrefix("/property:") {
        _task = value.stripNewLine
      }
    }
  }
  public var property: String {
    get { return _property }
    set (value) {
      if value == "" || value.hasPrefix("/t:") {
        _property = value.stripNewLine
      }
    }
  }
  public var solution: String {
    get { return _solution }
    set (value) {
      if value.hasSuffix(".sln") {
        _solution = value.stripNewLine
      }
    }
  }
  public var user = ""
  public var password = ""
  public var forceYes: Bool = false
}

// MARK: Private
private extension Options {
}

// MARK: Public
public extension Options {
  
  var description: String {
    get {
      return "{\"task\": \"\(task)\", \"property\": \"\(property)\", \"solution\": \"\(solution)\", \"user\": \"\(user)\", \"password\": \"\(password)\", \"forceYes\": \"\(forceYes)\"}";
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
    case "y": if let unwrapped = NSString(string: value!).boolValue as Bool?  {
      println("stringToBool: \(unwrapped)")
      self.forceYes = unwrapped
    } else if let int = value!.toInt(), let unwrapped = Bool(int) as Bool? {
      println("IntToBool: \(unwrapped)")
      self.forceYes = unwrapped
    } else {
      println("none: \(value)")
    }
    default: ""
    }
  }
}