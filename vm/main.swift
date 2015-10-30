//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Darwin

public class Main {
  public let Width: Int
  public let Answer: Bool?
  public let VMImage: String?
  public let DisplayHelp: Bool
  public let ClearSaveData: Bool
  public let TimeoutOnUpdate: useconds_t = 200000

  init () {
    if let cols = Int(shell("/usr/bin/tput", args: ["cols"]).stripWhiteSpaceAndNewLine) {
      self.Width = cols
    } else {
      self.Width = 80
    }

    var answer: Bool?
    var vmImage: String?
    var displayHelp: Bool = false
    var clearSaveData: Bool = false

    eachProcessArgument() {
      if $0 == "y" {
        answer = true
      }
      if $0 == "n" {
        answer = false
      }
      if $0 == "i" || $0 == "image" {
        vmImage = $0.stripWhiteSpaceAndNewLine
      }
      if $0 == "h" || $0 == "help" {
        displayHelp = true
      }
      if $0 == "c" || $0 == "clear" {
        clearSaveData = true
      }
    }

    self.Answer = answer
    self.VMImage = vmImage
    self.DisplayHelp = displayHelp
    self.ClearSaveData = clearSaveData
  }
}

public var main = Main()


if main.DisplayHelp {
  promptHelp()
}

App().msBuild(arguments())

exit(0)
