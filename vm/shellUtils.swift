//
//  shellUtils.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-18.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func repeat(value: String, repeateCount: Int) -> String {
  return "".join(Array(count: repeateCount, repeatedValue: value))
}

public func center(str: String) -> String {
  let odd = (WIDTH - count(str)) % 2 == 1
  let padding = Int(floor(Double(((WIDTH - count(str)) / 2))))
  
  func print(_ last: Bool = false) -> String {
    return repeat(" ", last && odd ? padding + 1 : padding)
  }
  
  return print() + str + print(true)
}

public func header(str: String) -> [String] {
  let r = ASCIIColor.reset
  let bbgb = r + ASCIIColor.Normal.white.rawValue + ASCIIColor.Background.blue.rawValue
  
  return [
    "\(bbgb)" + repeat(" ", WIDTH) + "\(r)",
    "\(bbgb)" + center("\(str)") + "\(r)",
    "\(bbgb)" + repeat(" ", WIDTH) + "\(r)"
  ]
}