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
      if argument.element.hasPrefix("-") {
        let indexInRange = argArray.count - 1 >= argument.index + 1
        var key = argument.element.stripDashes
        if indexInRange, let value = argArray[argument.index + 1] as String? {
          if value.hasPrefix("=") == false {
            options.update(key, value: value)
          }
        } else {
          options.update(key, value: "true")
        }
      }
    }
  }
  
  return options
}