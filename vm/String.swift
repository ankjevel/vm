//
//  String.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-14.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

extension String {
  
  var strip: String {
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
  
  var stripNewLine: String {
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
  }
  
  var removeQuotations: String {
    var modifiedString = self
    if self.hasPrefix("\"") {
      modifiedString = dropFirst(self)
    }
    if self.hasSuffix("\"") {
      modifiedString = dropLast(modifiedString)
    }
    return modifiedString
  }
  
  func contains(value: String) -> Bool {
    return self.lowercaseString.rangeOfString(value.lowercaseString) != nil
  }
}