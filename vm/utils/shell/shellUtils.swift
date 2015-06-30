//
//  shellUtils.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-18.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func repeat(value: String, repeateCount: Int) -> String {
  if repeateCount <= 0 {
    return ""
  }
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
  let bbgb = r + ASCIIColor.Normal.white + ASCIIColor.Background.blue
  
  return [
    "\(bbgb)" + repeat(" ", WIDTH) + "\(r)\n" +
    "\(bbgb)" + center("\(str)") + "\(r)\n" +
    "\(bbgb)" + repeat(" ", WIDTH) + "\(r)"
  ]
}


private func rpad(string: String, _ width: Int = WIDTH) -> String {
  let whitespace = repeat(" ", width - count(string))
  return "\(string)\(whitespace)"
}

public func loading(text: String, run: () -> Bool) {
  setbuf(__stdoutp, nil)
  println("\n")
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
    var i = -1
    let maxDots = 3
    while run() {
      let maxLength = (count(text) + maxDots) * 2
      let clear = repeat("\u{8}", maxLength)
      i = ++i % (maxDots + 1)
      let dots = repeat(".", i) + repeat(" ", maxDots - i)
      let message = rpad(" \(text) [\(ASCIIColor.Bold.blue)\(dots)\(ASCIIColor.reset)]", maxLength)
      
      print("\(clear)\(message)\(clear)")
      
      usleep(200000)
    }
  })
}