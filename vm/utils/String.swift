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
    var str = self
        .stringByReplacingOccurrencesOfString("\\\\", withString: "\\")
        .characters
        .split {
          $0 == "\\"
        }.map {
          String($0)
        }.joinWithSeparator("\\")
    
    if str.hasPrefix("\\\\") == false {
      if str.hasPrefix("\\") {
        str = "\\\(str)"
      } else if Array(str.characters)[1] != ":" {
        str = "\\\\\(str)"
      }
    }
    
    return str
  }
  
  func substringFromIndex(index: Int) -> String {
    return self.substringFromIndex(self.startIndex.advancedBy(index))
  }
  
  var removeQuotations: String {
    var modifiedString = self
    if self.hasPrefix("\"") {
      modifiedString = String(self.characters.dropFirst())
    }
    if self.hasSuffix("\"") {
      modifiedString = String(modifiedString.characters.dropLast())
    }
    return modifiedString
  }
  
  func instancesOf(value: String) -> Int {
    return self.componentsSeparatedByString(value).count
  }
  
  var bool: Bool {
    if let unwrapped = NSString(string: self).boolValue as Bool?  {
      return unwrapped
    } else if let int = Int(self), let unwrapped = Bool(int) as Bool? {
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