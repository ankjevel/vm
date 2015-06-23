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
  
  var stripWhiteSpaceAndNewLine: String {
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
  }
  
  var stripDashes: String {
    return self.stringByReplacingOccurrencesOfString("-", withString: "")
  }
  
  var windowsEcaping: String {
    return "\\".join(split(self.stringByReplacingOccurrencesOfString("\\\\", withString: "\\"), maxSplit: 1, allowEmptySlices: true){ $0 == "\\" })
  }
  
  func substringFromIndex(index:Int) -> String {
    return self.substringFromIndex(advance(self.startIndex, index))
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
  
  func instancesOf(value: String) -> Int {
    return self.componentsSeparatedByString(value).count
  }
  
  var bool: Bool {
    if let unwrapped = NSString(string: self).boolValue as Bool?  {
      return unwrapped
    } else if let int = self.toInt(), let unwrapped = Bool(int) as Bool? {
      return unwrapped
    } else if self.lowercaseString == "y" ||
      self.lowercaseString == "yes" ||
      self == "1" {
      return true
    } else {
      return false
    }
  }
  
  func contains(value: String, caseInsensitive: Bool = true) -> Bool {
    if caseInsensitive {
      return self.lowercaseString.rangeOfString(value.lowercaseString) != nil
    } else {
      return self.rangeOfString(value) != nil
    }
  }
}