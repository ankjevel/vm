//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

public let WIDTH: Int
public var ANSWER: Bool?

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
}

let app = App()


checkIfUserShouldBePromptedHelp()

app.msBuild(arguments())