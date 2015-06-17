//
//  ASCIIColor.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-17.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

enum ASCIIColor: String {
  
  case reset  = "\u{001B}[0m"
  
  // Regular Colors
  case black  = "\u{001B}[0;30m"
  case red    = "\u{001B}[0;31m"
  case green  = "\u{001B}[0;32m"
  case yellow = "\u{001B}[0;33m"
  case blue   = "\u{001B}[0;34m"
  case purple = "\u{001B}[0;35m"
  case cyan   = "\u{001B}[0;36m"
  case white  = "\u{001B}[0;37m"

  enum Bold: String {
    case black  = "\u{001B}[1;30m"
    case red    = "\u{001B}[1;31m"
    case green  = "\u{001B}[1;32m"
    case yellow = "\u{001B}[1;33m"
    case blue   = "\u{001B}[1;34m"
    case purple = "\u{001B}[1;35m"
    case cyan   = "\u{001B}[1;36m"
    case white  = "\u{001B}[1;37m"
  }
  
  enum Underline: String {
    case black  = "\u{001B}[4;30m"
    case red    = "\u{001B}[4;31m"
    case green  = "\u{001B}[4;32m"
    case yellow = "\u{001B}[4;33m"
    case blue   = "\u{001B}[4;34m"
    case purple = "\u{001B}[4;35m"
    case cyan   = "\u{001B}[4;36m"
    case white  = "\u{001B}[4;37m"
  }
  
  enum Background: String {
    case black  = "\u{001B}[40m"
    case red    = "\u{001B}[41m"
    case green  = "\u{001B}[42m"
    case yellow = "\u{001B}[43m"
    case blue   = "\u{001B}[44m"
    case purple = "\u{001B}[45m"
    case cyan   = "\u{001B}[46m"
    case white  = "\u{001B}[47m"
  }
  
  enum HighIntensity: String {
    case black  = "\u{001B}[0;90m"
    case red    = "\u{001B}[0;91m"
    case green  = "\u{001B}[0;92m"
    case yellow = "\u{001B}[0;93m"
    case blue   = "\u{001B}[0;94m"
    case purple = "\u{001B}[0;95m"
    case cyan   = "\u{001B}[0;96m"
    case white  = "\u{001B}[0;97m"
  }
  
  enum BoldHighIntensity: String {
    case black  = "\u{001B}[1;90m"
    case red    = "\u{001B}[1;91m"
    case green  = "\u{001B}[1;92m"
    case yellow = "\u{001B}[1;93m"
    case blue   = "\u{001B}[1;94m"
    case purple = "\u{001B}[1;95m"
    case cyan   = "\u{001B}[1;96m"
    case white  = "\u{001B}[1;97m"
  }
  
  enum HighIntensityBackground: String {
    case black  = "\u{001B}[0;100m"
    case red    = "\u{001B}[0;101m"
    case green  = "\u{001B}[0;102m"
    case yellow = "\u{001B}[0;103m"
    case blue   = "\u{001B}[0;104m"
    case purple = "\u{001B}[0;105m"
    case cyan   = "\u{001B}[0;106m"
    case white  = "\u{001B}[0;107m"
  }
}