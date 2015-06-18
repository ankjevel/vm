//
//  msbuild.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-18.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public struct MSBuild {
  
  private let OS_DOCUMENTS = "~/Documents/".stringByExpandingTildeInPath
  private let VM_DOCUMENTS = "\\\\vmware-host\\Shared Folders\\Documents\\"
  private let VM_FILE_BUILD = "build.bat"
  private let VM_FILE_LOG = "out.log"
}

// MARK: Public
public extension MSBuild {
  
  func run(selected: FeedbackItem) {
    println(selected)
    touchLogFile()
  }
}

// MARK: Private
private extension MSBuild {

  func touchLogFile() {
    println("\(OS_DOCUMENTS)/\(VM_FILE_LOG)")
    if NSFileManager().fileExistsAtPath("\(OS_DOCUMENTS)/\(VM_FILE_LOG)") == false {
      println("no")
    } else {
      println("yes")
    }
  }
}