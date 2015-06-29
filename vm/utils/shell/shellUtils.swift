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
  let bbgb = r + ASCIIColor.Normal.white + ASCIIColor.Background.blue
  
  return [
    "\(bbgb)" + repeat(" ", WIDTH) + "\(r)\n" +
    "\(bbgb)" + center("\(str)") + "\(r)\n" +
    "\(bbgb)" + repeat(" ", WIDTH) + "\(r)"
  ]
}


private func rpad(string: String) -> String {
  let whitespace = repeat(" ", WIDTH - count(string))
  return "\(string)\(whitespace)"
}

public func loading(text: String, run: () -> Bool) {
  setbuf(__stdoutp, nil)
  println("\n")
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
    var i = -1
    while run() {
      let clear = repeat("\u{8}", WIDTH)
      i = ++i % 3
      let dots = repeat(".", i + 1)
      let message = rpad("\(text) \(ASCIIColor.Bold.blue)\(dots)\(ASCIIColor.reset)")
      print("\(clear)\(message)")
      sleep(1)
    }
  })
}