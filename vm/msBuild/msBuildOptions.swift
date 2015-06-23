//
//  msBuildOptions.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class MSBuildOptions: Printable {

  public var user = MSBuildOption("", "user") {
    $0 != ""
  }
  
  public var password = MSBuildOption("", "password") {
    $0 != ""
  }
  
  public var solution = MSBuildOption("", "solution") {
    $0.hasSuffix(".sln") && $0.instancesOf("\\\\") > 1
  }
  
  public var property = MSBuildOption("", "property") {
    $0 == "" || $0.hasPrefix("/property:")
  }
  
  public var task = MSBuildOption("", "task") {
    $0 == "" || $0.hasPrefix("/t:")
  }
  
  public var msbuild = MSBuildOption("C:\\Program Files (x86)\\MSBuild\\12.0\\bin\\MSBuild.exe", "msbuild") {
    $0.hasSuffix(".exe")
  }
}

// MARK: Private
private extension MSBuildOptions {
}

// MARK: Public
public extension MSBuildOptions {
  
  var description: String {
    get {
      var description: [String: AnyObject] = [
        "task": task.value,
        "property": property.value,
        "solution": solution.value,
        "user": user.value,
        "password": password.value,
        "msbuild": msbuild.value,
        "task set": task.set,
        "property set": property.set,
        "solution set": solution.set
      ]
      return "\(description)";
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
    default: ""
    }
  }
}