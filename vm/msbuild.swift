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
    }
    self = .Unknown
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
    let status = checkIfSolutionExists(selected)
    if status != .FileExists {
      halt(status.rawValue)
    }
  }
}

// MARK: Private
private extension MSBuild {
  
  func checkIfSolutionExists(selected: FeedbackItem) -> Response {
    let (response, error) = vmware.runAndPassError([
      "-gu",
      "foo",
      "-gp",
      "\(selected.options.password)",
      "fileExistsInGuest",
      "\(selected.id)",
      "\(selected.options.solution.removeQuotations.windowsEcaping)"])
    return Response(response, error)
  }
}