//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

let vm = VMWare()

func msBuild([String: String] = [String: String]()) -> [VMConfig] {
  return vm.list.filter({ $0.os.contains("windows") })
}

//let res = shell("echo", "hello", "world")
//println("\(res)")

let build = msBuild()
println(build)
