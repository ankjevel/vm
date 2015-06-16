//
//  FeedbackItem.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-14.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class FeedbackItem: Printable {
  
  public var title: String
  public var id: String
  public var argument: String
  public var type: String
  public var options = Options()
  
  init(title: String, id: String = "", argument: String = "", type: String = "default") {
    self.title = title
    self.type = type
    
    if id == "" {
      self.id = "\(NSDate().timeIntervalSince1970 * 1000)\(title)"
    } else {
      self.id = id
    }
    
    if argument == "" {
      self.argument = title
    } else {
      self.argument = argument
    }
  }
}

// MARK: Public
public extension FeedbackItem {
  
  var description: String {
    get {
      return "{\"title\": \"\(title)\", \"id\": \"\(id)\", \"argument\": \"\(argument)\", \"type\": \"\(type)\", \"options\": \"\(options)\"}";
    }
  }
}