//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

public let WIDTH: Int
if let cols = shell("tput",  "cols").stripWhiteSpaceAndNewLine.toInt() {
  WIDTH = cols
} else {
  WIDTH = 80
}

let app = App()

checkIfUserShouldBePromptedHelp()

app.msBuild(arguments())

