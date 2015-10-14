//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Darwin

public let WIDTH: Int
public var ANSWER: Bool?
public var VM_IMAGE: String?
public var DISPLAY_HELP: Bool = false
public var CLEAR_SAVE_DATA: Bool = false
public var SHOW_LOADING = false
public let TIMEOUT_ON_UPDATE: useconds_t = 200000

if let cols = Int(shell("/usr/bin/tput", args: ["cols"]).stripWhiteSpaceAndNewLine) {
  WIDTH = cols
} else {
  WIDTH = 80
}

eachProcessArgument() {
  if $0 == "y" {
    ANSWER = true
  }
  if $0 == "n" {
    ANSWER = false
  }
  if $0 == "i" || $0 == "image" {
    VM_IMAGE = $0.stripWhiteSpaceAndNewLine
  }
  if $0 == "h" || $0 == "help" {
    DISPLAY_HELP = true
  }
  if $0 == "c" || $0 == "clear" {
    CLEAR_SAVE_DATA = true
  }
}

if DISPLAY_HELP {
  promptHelp()
}

App().msBuild(arguments())

exit(0)