//
//  arguments.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func arguments() -> Options {
  var argArray = [String](Process.arguments)
  argArray.removeAtIndex(0)
  
  var options = Options()
  
  if argArray.count > 0 {
    for argument in enumerate(argArray) {
      if argument.element.hasPrefix("-"), var value = argArray[argument.index + 1] as String? {
        var key = argument.element.stripDashes
        options.update(key, value: value)
      }
    }
  }
  
  return options
}