//
//  Response.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-10-30.
//  Copyright © 2015 dennisp.se. All rights reserved.
//

import Foundation

public enum Response: String {

  case OK = "OK"
  case FileExists = "File exists"
  case FileDoesNotExist = "File does not exist"
  case DirectoryExists = "Directory exists"
  case DirectoryDoesNotExist = "Directory does not exist"
  case Credentials = "Username/Password incorrect"
  case Unknown = "Something went wrong. It could be wrong username. Did you forget your domain? ex: `COMPANY\\user`"

  init(_ response: String, _ error: String) {
    if response.contains("file exists") {
      self = .FileExists
    } else if response.contains("file does not") || error.contains("file does not") {
      self = .FileDoesNotExist
    } else if response.contains("directory exists") {
      self = .DirectoryExists
    } else if response.contains("directory does not") || error.contains("directory does not") {
      self = .DirectoryDoesNotExist
    } else if response.contains("unknown") || error.contains("unkown") {
      self = .Credentials
    } else if error == "" {
      self = .OK
    } else {
      self = .Unknown
    }
  }
}
