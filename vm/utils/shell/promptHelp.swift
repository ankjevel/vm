//
//  checkIfUserShouldBePromptedHelp.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-17.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Darwin
import Foundation

public func promptHelp() {
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
    "\(bw)-m\(r) --msbuild    msbuild executable file in windows",
    "                \(bw)C:\\Program Files (x86)\\MSBuild\\12.0\\bin\\MSBuild.exe\(r)",
    "\(bw)-y\(r)              answers \"YES\", when prompted",
    "",
    "\(bw)-n\(r)              answers \"NO\", when prompted",
    "",
    "\(bw)-c\(r) --clear      clears core-data storage",
    "",
    "\(bw)-h\(r) --help       prints this guide",
    ""
  ]
  
  println("\n".join(helpMessage))
  exit(0)
}