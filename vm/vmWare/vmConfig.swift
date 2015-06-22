//
//  vmconfig.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

public class VMConfig: Printable {
  
  public var path = ""
  public var name = ""
  public var status = "Stopped"
  public var ipAddress = ""
  public var os = ""
}

// MARK: Public
public extension VMConfig {

  var running: Bool {
    get {
      return self.status != "Stopped"
    }
  }
  
  var description: String {
    get {
      return "{" +
        "\"path\": \"\(path)\", " +
        "\"name\": \"\(name)\", " +
        "\"status\": \"\(status)\", " +
        "\"ipAddress\": \"\(ipAddress)\", " +
        "\"os\": \"\(os)\", " +
        "\"running\": \"\(running)\"" +
      "}";
    }
  }
}