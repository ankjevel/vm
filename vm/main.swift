//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

public let WIDTH: Int
public var ANSWER: Bool?
public var VM_IMAGE: String?
public var DISPLAY_HELP: Bool = false
public var CLEAR_CORE_DATA: Bool = false

if let cols = shell("/usr/bin/tput", ["cols"]).stripWhiteSpaceAndNewLine.toInt() {
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
    CLEAR_CORE_DATA = true
  }
}

if DISPLAY_HELP {
  promptHelp()
}

let app = App()


app.msBuild(arguments())