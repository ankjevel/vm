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
  case FolderExists = "Folder exists"
  case Credentials = "Username/Password incorrect"
  case Unknown = "Something went wrong"
  
  init(_ response: String, _ error: String) {
    if response.contains("file exists") {
      self = .FileExists
    } else if response.contains("directory exists") {
      self = .FolderExists
    } else if response.contains("unknown") || error.contains("unkown") {
      self = .Credentials
    } else if error == "" {
      self = .OK
    } else {
      self = .Unknown
    }
  }
}

public class MSBuild {
  private var _selected: FeedbackItem?
  private let vmware: VMWare
  
  var selected: FeedbackItem {
    get {
      return _selected!
    }
    set (selected) {
      self._selected = selected
    }
  }
  
  init (inout vmware: VMWare) {
    self.vmware = vmware
  }
}

// MARK: Public
public extension MSBuild {
  
  func run() {
    checkIfFileExists(selected.options.solution.value.removeQuotations.windowsEcaping)
    checkIfFileExists(selected.options.msbuild.value.removeQuotations.windowsEcaping)
    
    vmWareRequest([
      "directoryExistsInGuest",
      selected.id,
      "C:\\temp"
    ])
  }
}

// MARK: Private
private extension MSBuild {
  
  var auth: [String] {
    get {
      return [
        "-gu",
        selected.options.user.value,
        "-gp",
        selected.options.password.value
      ]
    }
  }
  
  func vmWareRequest(args: [String]) -> (response: String, error: String) {
    return vmware.runAndPassError(auth + args)
  }
  
  func vmWareRequest(args: [String], _ checkAgainst: Response) -> (Bool, Response) {
    let (response, error) = vmWareRequest(args)
    let status = Response(response, error)
    
    return (status == checkAgainst, status)
  }
  
  func createBuildScript() {
    
  }
  
  func sendBuildScript() {
    
  }

  func checkIfFileExists(file: String) -> Void {
    let (ok, status) = vmWareRequest([
      "fileExistsInGuest",
      selected.id,
      file
    ], .FileExists)
    
    if ok == false {
      halt(status.rawValue)
    }
  }
}