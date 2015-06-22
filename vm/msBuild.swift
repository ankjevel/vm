//
//  msbuild.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-18.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

internal enum Response: String {
  
  case OK = "OK"
  case FileExists = "File exists"
  case Credentials = "Username/Password incorrect"
  case Unknown = "Something went wrong"
  
  init(_ response: String, _ error: String) {
    if response.contains("file exists") {
      self = .FileExists
    } else if response.contains("unknown") || error.contains("unkown") {
      self = .Credentials
    } else if error == "" {
      self = .OK
    } else {
      self = .Unknown
    }
  }
}

public struct MSBuild {
  
  private let vmware: VMWare
  
  init (inout vmware: VMWare) {
    self.vmware = vmware
  }
}

// MARK: Public
public extension MSBuild {
  
  func run(selected: FeedbackItem) {
    checkIfFileExists(selected.options.solution.value.removeQuotations.windowsEcaping, selected)
    checkIfFileExists(selected.options.msbuild.value.removeQuotations.windowsEcaping, selected)
    println("now what")
  }
}

// MARK: Private
private extension MSBuild {
  func checkIfFileExists(file: String, _ selected: FeedbackItem) -> Void {
    let (response, error) = vmware.runAndPassError([
      "-gu",
      "\(selected.options.user.value)",
      "-gp",
      "\(selected.options.password.value)",
      "fileExistsInGuest",
      "\(selected.id)",
      "\(file)"])
    let status = Response(response, error)
    if status != .FileExists {
      halt(status.rawValue)
    }
  }
}