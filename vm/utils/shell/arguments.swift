//
//  arguments.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func arguments() -> MSBuildOptions {
  var argArray = [String](Process.arguments)
  argArray.removeAtIndex(0)

  let options = MSBuildOptions()

  if argArray.count > 0 {
    for argument in argArray.enumerate() {
      if argument.element.hasPrefix("-") {
        let indexInRange = argArray.count - 1 >= argument.index + 1
        let key = argument.element.stripDashes
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
