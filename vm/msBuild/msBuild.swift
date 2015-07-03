//
//  msbuild.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-18.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import Dispatch
import Darwin

internal struct Paths {
  
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
    static let temp = "~/temp".stringByExpandingTildeInPath
    static let log = "\(temp)/\(Paths.File.log)"
    static let script = "\(temp)/\(Paths.File.script)"
  }
}

internal enum Response: String {
  
  case OK = "OK"
  case FileExists = "File exists"
  case FileDoesNotExist = "File does not exist"
  case DirectoryExists = "Directory exists"
  case DirectoryDoesNotExist = "Directory does not exist"
  case Credentials = "Username/Password incorrect"
  case Unknown = "Something went wrong. It could be wrong username. Did you forget your domain? ex: `COMPANY\\user`"
  
  init(_ response: String, _ error: String) {
    if response.contains("file exists") {
      self = .FileExists
    } else if response.contains("file does not") || error.contains("file does not") {
      self = .FileDoesNotExist
    } else if response.contains("directory exists") {
      self = .DirectoryExists
    } else if response.contains("directory does not") || error.contains("directory does not") {
      self = .DirectoryDoesNotExist
    } else if response.contains("unknown") || error.contains("unkown") {
      self = .Credentials
    } else if error == "" {
      self = .OK
    } else {
      self = .Unknown
    }
  }
}

public class MSBuild {
  private var _selected: FeedbackItem?
  private let vmware: VMWare
  private let fm = NSFileManager()
  
  var selected: FeedbackItem {
    get {
      return _selected!
    }
    set (selected) {
      self._selected = selected
    }
  }
  
  init (inout vmware: VMWare) {
    self.vmware = vmware
  }
}

// MARK: Public
public extension MSBuild {
  

  func run() {
    
    var stage = 0
    
    // MARK: Prerequisits
    loading("Checking prerequisits") {
      return stage == 0
    }
    prerequisits(&stage)
    
    
    // MARK: Create scripts
    loading("Creating build script") {
      return stage == 1
    }
    createBuildScript(&stage)

    // MARK: Build
    loading("Building solution") {
      return stage == 2
    }
    sendBuildScript(&stage)
  }
}

// MARK: Private
private extension MSBuild {
  
  var auth: [String] {
    get {
      return [
        "-gu", selected.options.user.value,
        "-gp", selected.options.password.value
      ]
    }
  }
  
  func ok(string: String) {
    ok(count(string))
  }
  func ok(_ repeats: Int = 7) {
    if repeats > 0 {
      let moveLeft = repeat("\u{8}", repeats)
      let spaces = repeat(" ", repeats)
      print("\(moveLeft)\(spaces)\(moveLeft)")
    }

    println("\(ASCIIColor.Bold.green)√\(ASCIIColor.reset)")
  }
  
  func vmWareRequest(args: [String]) -> (response: String, error: String) {
    return vmware.runAndPassError(auth + args)
  }
  
  func vmWareRequest(args: [String], _ checkAgainst: Response) -> (ok: Bool, status: Response) {
    let (response, error) = vmWareRequest(args)
    let status = Response(response, error)
    
    return (status == checkAgainst, status)
  }
  
  func prerequisits(inout stage: Int) {
    checkIfExists(selected.options.solution.value.removeQuotations.windowsEcaping, .FileExists)
    checkIfExists(selected.options.msbuild.value.removeQuotations.windowsEcaping, .FileExists)
    if checkIfExists(Paths.Windows.temp, .DirectoryExists, haltOnError: false) == false {
      vmWareRequest([
        "createDirectoryInGuest",
        selected.id,
        Paths.Windows.temp
        ])
    }
    checkIfExists(Paths.Windows.temp, .DirectoryExists)

    ++stage; ok("[...]  ")
  }

  func checkIfExists(path: String, _ res: Response, haltOnError: Bool = true) -> Bool {
    var type = res == .FileExists ? "file" : "directory"
    let (ok, status) = vmWareRequest([
      "\(type)ExistsInGuest",
      selected.id,
      path
    ], res)
    
    if haltOnError && ok == false {
      halt(status.rawValue, res == .FileExists ? 200 : 201, selected.title)
    }
    
    return ok
  }
  
  func createBuildScript(inout stage: Int) {
    var file: String = "\r\n".join([
      "c:\\",
      "CALL " +
        "\"\(selected.options.msbuild.value.removeQuotations.windowsEcaping)\" " +
        "\"\(selected.options.solution.value.removeQuotations.windowsEcaping)\" " +
        "\(selected.options.task.value) " +
        "\(selected.options.property.value)" +
        " >> " +
        "\"\(Paths.Windows.log)\"" +
      ""
    ])
    
    var error: NSError?
    if fm.fileExistsAtPath(Paths.OSX.temp) == false {
      fm.createDirectoryAtPath(Paths.OSX.temp, withIntermediateDirectories: true, attributes: nil, error: &error)
    }
    if error != nil {
      halt("could not create temp folder", 202, selected.title)
    }

    if checkIfExists(Paths.Windows.script, .FileExists, haltOnError: false) == true {
      vmWareRequest(["deleteFileInGuest", selected.id, Paths.Windows.script])
    }
    
    if checkIfExists(Paths.Windows.log, .FileExists, haltOnError: false) == true {
      vmWareRequest(["deleteFileInGuest", selected.id, Paths.Windows.log])
    }
    
    let data = (file as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    if fm.createFileAtPath(Paths.OSX.script, contents: data, attributes: nil) == false {
      halt("could not create script file", 203, selected.title)
    }
    
    ++stage; ok("[...]  ")
  }
  
  func sendBuildScript(inout stage: Int) {
    vmWareRequest(["CopyFileFromHostToGuest", selected.id, Paths.OSX.script, Paths.Windows.script])
    
    if checkIfExists(Paths.Windows.script, .FileExists, haltOnError: false) == false {
      halt("script not present in guest", 204, selected.title)
    }
    
    vmWareRequest([
      "runProgramInGuest",
      selected.id,
      Paths.Windows.cmd,
      "/c \"\(Paths.Windows.script)\""
    ])
    
    readLogs(&stage)
  }
  
  func readLogs(inout stage: Int) {
    if checkIfExists(Paths.Windows.log, .FileExists, haltOnError: false) == false {
      halt("logs where not created!", 205, selected.title)
    }
    vmWareRequest(["CopyFileFromGuestToHost", self.selected.id, Paths.Windows.log, Paths.OSX.log])
    let success: Bool
    let file: String
    
    if let data = fm.contentsAtPath(Paths.OSX.log),
      let dataAsString = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
        file = dataAsString
        success = file.contains("Build succeeded.")
    } else {
      file = ""
      success = false
    }
    
    ++stage; ok("[...]  ")
    
    if success {
      var index = file.rangeOfString("Build succeeded.")!.startIndex
      let part = file.substringFromIndex(index)
      println("\(ASCIIColor.Bold.green)\n\(part)\(ASCIIColor.reset)")
    } else {
      println(file)
      println("\(ASCIIColor.Bold.red)\nbuild not successful\(ASCIIColor.reset)")
    }
  }
}