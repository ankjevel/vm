//
//  shellUtils.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-18.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func repeatString(value: String, repeatCount: Int) -> String {
  if repeatCount <= 0 {
    return ""
  }
  return Array(count: repeatCount, repeatedValue: value).joinWithSeparator("")
}

public func center(str: String) -> String {
  let odd = (main.Width - str.characters.count) % 2 == 1
  let padding = Int(floor(Double(((main.Width - str.characters.count) / 2))))

  func print(last: Bool = false) -> String {
    return repeatString(" ", repeatCount: last && odd ? padding + 1 : padding)
  }

  return print() + str + print(true)
}

public func header(str: String) -> [String] {
  let r = ASCIIColor.reset
  let bbgb = r + ASCIIColor.Normal.white + ASCIIColor.Background.blue

  return [
    "\(bbgb)" + repeatString(" ", repeatCount: main.Width) + "\(r)\n" +
    "\(bbgb)" + center("\(str)") + "\(r)\n" +
    "\(bbgb)" + repeatString(" ", repeatCount: main.Width) + "\(r)"
  ]
}


private func rpad(string: String, _ width: Int = main.Width) -> String {
  let whitespace = repeatString(" ", repeatCount: width - string.characters.count)
  return "\(string)\(whitespace)"
}

public func loading(text: String, run: () -> Bool) {
  setbuf(__stdoutp, nil)
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
    var i = -1
    let maxDots = 3
    while run() {
      let clear = "\r"
      i = ++i % (maxDots + 1)
      let dots = repeatString(".", repeatCount: i) + repeatString(" ", repeatCount: maxDots - i)
      let message = "\(text) [\(ASCIIColor.Bold.blue)\(dots)\(ASCIIColor.reset)]  "

      print("\(clear)\(message)", terminator: "")

      usleep(main.TimeoutOnUpdate)
    }
  })
}
