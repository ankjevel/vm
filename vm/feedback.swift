//
//  feedback.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-14.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public
class Feedback {
  
  public
  var items: [FeedbackItem] = []
  
  public
  func addItem(item: FeedbackItem) -> FeedbackItem {
    items.append(item)
    return item
  }
  
  init() {}
}