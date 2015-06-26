//
//  vmconfig.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

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
      
      var description: [String: AnyObject] = [
        "path": path,
        "name": name,
        "status": status,
        "ipAddress": ipAddress,
        "os": os,
        "running": running
      ]
      
      if
        let data = NSJSONSerialization.dataWithJSONObject(description, options: .PrettyPrinted, error: nil),
        let json = NSString(data: data, encoding: NSUTF8StringEncoding) {
          return json as String
      } else {
        return ""
      }
    }
  }
}