//
//  main.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Darwin

let app = App()

ifShouldShowHelp()

app.msBuild(arguments())

