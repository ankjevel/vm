//
//  msBuildOptions.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class MSBuildOptions: Printable {

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
  
  public var msbuild = MSBuildOption("C:\\Program Files (x86)\\MSBuild\\12.0\\bin\\MSBuild.exe", "msbuild", { (value: String) -> Bool in
    return value.hasSuffix(".exe")
  })

  public var answer: Bool?
}

// MARK: Private
private extension MSBuildOptions {
}

// MARK: Public
public extension MSBuildOptions {
  
  var description: String {
    get {
      return "{" +
        "\"task\": \"\(task.value)\", " +
        "\"property\": \"\(property.value)\", " +
        "\"solution\": \"\(solution.value)\", " +
        "\"user\": \"\(user.value)\", " +
        "\"password\": \"\(password.value)\", " +
        "\"msbuild\": \"\(msbuild.value)\", " +
        "\"answer\": \"\(answer)\", " +
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
    case "msbuild", "m": self.msbuild.value = value!
    case "n": self.answer = false
    case "y": self.answer = true
    default: ""
    }
  }
}