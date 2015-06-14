//
//  FeedbackItem.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-14.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public
class FeedbackItem {
  
  public
  var title: String,
      id: String,
      argument: String,
      type: String
  
  init(title: String, id: String? = nil, argument: String? = nil, type: String = "default") {
    self.title = title
    self.type = type
    
    if id == nil {
      self.id = "\(NSDate().timeIntervalSince1970 * 1000)\(title)"
    } else {
      self.id = id!
    }
    
    if argument == nil {
      self.argument = title
    } else {
      self.argument = argument!
    }
  }
}