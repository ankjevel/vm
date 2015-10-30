//
//  shell.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public func shell(cmd: String, args: [String]) -> String {
  let (response, _) = createTask(cmd, arguments: args)

  return response
}

public func shell(cmd: String, printError: Bool, args: [String]) -> (String, String) {
  let (response, errorResponse) = createTask(cmd, arguments: args)

#if Debug
  print("response: \(response)\nerrorResponse: \(errorResponse)")
#endif

  return (response, errorResponse)
}
