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

  let buildOptions: [String] = [
    "",
    "\(bw)-t\(r), --task:",
    "    [msbuild task argument]",
    "    \(bw)default: /t:build\(r)",
    "    ex: \(bw)-t /t:build\(r)",
    "",
    "\(bw)-o\(r), --property:",
    "    [msbuild properties for task]",
    "    \(bw)default: /property:Configuration=Debug\(r)",
    "    ex: \(bw)-o /property:Configuration=Debug\(r)",
    "",
    "\(bw)-s\(r), --solution:",
    "    [solution file to build]",
    "    ex: \(bw)-s \"c:\\dev\\some project\\project.sln\"\(r)",
    "",
    "\(bw)-u\(r), --user:",
    "    [guest user in vm (don't forget your domain (`COMPANY\\user`))]",
    "    ex: \(bw)-u BAZ\\foo\(r)",
    "",
    "\(bw)-p\(r), --password:",
    "    [password for guest user]",
    "    ex: \(bw)-p bar\(r)",
    "",
    "\(bw)-m\(r), --msbuild:",
    "    [msbuild executable file in windows]",
    "    ex: \(bw)-m \"C:\\Program Files (x86)\\MSBuild\\12.0\\bin\\MSBuild.exe\"\(r)",
    ""
  ]

  let globalOptions: [String] = [
    "",
    "\(bw)-i\(r), --image:",
    "    [select a specific image (if name CONTAINS this string)]",
    "    ex: \(bw)-i VisualStudioOs\(r)",
    "",
    "\(bw)-y\(r):",
    "    answers \"YES\", when prompted",
    "",
    "\(bw)-n\(r):",
    "    answers \"NO\", when prompted",
    "",
    "\(bw)-c\(r), --clear:",
    "    clear previously saved data",
    "",
    "\(bw)-h\(r), --help:",
    "    prints this guide"
  ]
  let helpMessage: [String] = header("BUILD OPTIONS") + buildOptions + header("GLOBAL OPTIONS") + globalOptions

  print(helpMessage.joinWithSeparator("\n"))
  exit(0)
}
