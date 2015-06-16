//
//  showHelp.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-17.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Darwin
import Foundation

public func ifShouldShowHelp() {
  var argArray = [String](Process.arguments)
  for arg in argArray {
    let argument = arg.strip.stripDashes.lowercaseString
    if argument == "h" || argument == "help" {
      println("Available options:\n" +
        "Argument        Default value\n\n" +
        "-t --task       /t:build\n" +
        "-o --property   /property:Configuration=Debug\n" +
        "-s --solution   \"\"\n" +
        "-u --user       \"\"\n" +
        "-p --password   \"\"\n" +
        "-h --help       prints this guide")
      exit(0)
    }
  }
}

