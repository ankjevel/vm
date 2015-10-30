//
//  Paths.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-10-30.
//  Copyright © 2015 dennisp.se. All rights reserved.
//

import Foundation

public struct Paths {

  struct File {
    static let script = "build.bat"
    static let log = "out.log"
  }

  struct Windows {
    static let temp = "C:\\temp"
    static let log = "\(temp)\\\(Paths.File.log)"
    static let script = "\(temp)\\\(Paths.File.script)"
    static let cmd = "C:\\WINDOWS\\system32\\cmd.exe"
  }

  struct OSX {
    static let temp = NSString(string: "~/temp").stringByExpandingTildeInPath
    static let log = "\(temp)/\(Paths.File.log)"
    static let script = "\(temp)/\(Paths.File.script)"
  }
}
