//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

let app = App()


var argArray = [String](Process.arguments)
argArray.removeAtIndex(0)

var options = Option()

if argArray.count > 0 {
  for argument in enumerate(argArray) {
    if argument.element.hasPrefix("-"), var value = argArray[argument.index + 1] as String? {
      var key = argument.element.stringByReplacingOccurrencesOfString("-", withString: "")
      options.update(key, value: value)
    }
  }
}

println(options)
//let args = "\"" + "\";\"".join(argArray.map({ $0.removeQuotations })) + "\""

//for argument in args {
//  println(argument)
//}
//println(args)

app.msBuild()

