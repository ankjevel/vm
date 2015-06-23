//
//  FeedbackItem.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-14.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class FeedbackItem: Printable {
  
  public let title: String
  public let id: String
  public var running: Bool
  public var options = MSBuildOptions()
  
  init(title: String, id: String = "", running: Bool) {
    self.title = title
    self.running = running
    
    if id == "" {
      self.id = "\(NSDate().timeIntervalSince1970 * 1000)\(title)"
    } else {
      self.id = id
    }
  }
}

// MARK: Public
public extension FeedbackItem {
  
  var description: String {
    get {
      
      var description: [String: AnyObject] = [
        "title": title,
        "id": id,
        "running": running,
        "options": options
      ]
    
      return "\(description)";
    }
  }
}