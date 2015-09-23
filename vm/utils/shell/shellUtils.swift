//
//  shellUtils.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-18.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func `repeat`(value: String, repeatCount: Int) -> String {
  if repeatCount <= 0 {
    return ""
  }
  return Array(count: repeatCount, repeatedValue: value).joinWithSeparator("")
}

public func center(str: String) -> String {
  let odd = (WIDTH - str.characters.count) % 2 == 1
  let padding = Int(floor(Double(((WIDTH - str.characters.count) / 2))))
  
  func print(last: Bool = false) -> String {
    return `repeat`(" ", repeatCount: last && odd ? padding + 1 : padding)
  }
  
  return print() + str + print(true)
}

public func header(str: String) -> [String] {
  let r = ASCIIColor.reset
  let bbgb = r + ASCIIColor.Normal.white + ASCIIColor.Background.blue
  
  return [
    "\(bbgb)" + `repeat`(" ", repeatCount: WIDTH) + "\(r)\n" +
    "\(bbgb)" + center("\(str)") + "\(r)\n" +
    "\(bbgb)" + `repeat`(" ", repeatCount: WIDTH) + "\(r)"
  ]
}


private func rpad(string: String, _ width: Int = WIDTH) -> String {
  let whitespace = `repeat`(" ", repeatCount: width - string.characters.count)
  return "\(string)\(whitespace)"
}

public func loading(text: String, run: () -> Bool) {
  setbuf(__stdoutp, nil)
//  println("\n")
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
    var i = -1
    let maxDots = 3
    while run() {
      let clear = "\r"
      i = ++i % (maxDots + 1)
      let dots = `repeat`(".", repeatCount: i) + `repeat`(" ", repeatCount: maxDots - i)
      let message = "\(text) [\(ASCIIColor.Bold.blue)\(dots)\(ASCIIColor.reset)]  "
      
      print("\(clear)\(message)", terminator: "")
      
      usleep(TIMEOUT_ON_UPDATE)
    }
  })
}