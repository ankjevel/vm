//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

let vm = VMWare()

println(vm.list)

let res = shell("echo", "hello", "world")
println("\(res)")


