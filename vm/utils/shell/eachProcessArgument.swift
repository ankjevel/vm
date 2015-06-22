//
//  eachProcessArgument.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-22.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func eachProcessArgument(each: (String) -> Void) {
  var argArray = [String](Process.arguments)
  for arg in argArray {
    let argument = arg.strip.stripDashes.lowercaseString
    each(argument)
  }
}