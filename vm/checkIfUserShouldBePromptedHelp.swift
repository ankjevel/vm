//
//  checkIfUserShouldBePromptedHelp.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-17.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Darwin
import Foundation

public func checkIfUserShouldBePromptedHelp() {
  let r = ASCIIColor.reset
  let bw = ASCIIColor.Bold.white
  let bbgb = r + ASCIIColor.Normal.white + ASCIIColor.Background.blue

  let helpMessage: [String] = [
    ""
    ] + header("Available options") + [
    "",
    "Argument        Description",
    "                Default value",
    "",
    "\(bw)-t\(r) --task       msbuild task argument",
    "                \(bw)/t:build\(r)",
    "",
    "\(bw)-o\(r) --property   msbuild properties for task",
    "                \(bw)/property:Configuration=Debug\(r)",
    "",
    "\(bw)-s\(r) --solution   solution file to build",
    "",
    "\(bw)-u\(r) --user       guest user in vm",
    "",
    "\(bw)-p\(r) --password   password for guest user",
    "",
    "\(bw)-y\(r)              answers \"YES\", when prompted",
    "",
    "\(bw)-c\(r) --clear      clears core-data storage",
    "",
    "\(bw)-h\(r) --help       prints this guide",
    ""
  ]

  var argArray = [String](Process.arguments)
  for arg in argArray {
    let argument = arg.strip.stripDashes.lowercaseString
    if argument == "h" || argument == "help" {
      println("\n".join(helpMessage))
      exit(0)
    }
  }
}