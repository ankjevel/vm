//
//  ASCIIColor.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-17.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

public struct ASCIIColor {
  
  static let reset = "\u{001B}[0m"
  
  public struct Normal {
    static let black  = "\u{001B}[0;30m"
    static let red    = "\u{001B}[0;31m"
    static let green  = "\u{001B}[0;32m"
    static let yellow = "\u{001B}[0;33m"
    static let blue   = "\u{001B}[0;34m"
    static let purple = "\u{001B}[0;35m"
    static let cyan   = "\u{001B}[0;36m"
    static let white  = "\u{001B}[0;37m"
  }
  
  public struct Bold {
    static let black  = "\u{001B}[1;30m"
    static let red    = "\u{001B}[1;31m"
    static let green  = "\u{001B}[1;32m"
    static let yellow = "\u{001B}[1;33m"
    static let blue   = "\u{001B}[1;34m"
    static let purple = "\u{001B}[1;35m"
    static let cyan   = "\u{001B}[1;36m"
    static let white  = "\u{001B}[1;37m"
  }
  
  public struct Underline {
    static let black  = "\u{001B}[4;30m"
    static let red    = "\u{001B}[4;31m"
    static let green  = "\u{001B}[4;32m"
    static let yellow = "\u{001B}[4;33m"
    static let blue   = "\u{001B}[4;34m"
    static let purple = "\u{001B}[4;35m"
    static let cyan   = "\u{001B}[4;36m"
    static let white  = "\u{001B}[4;37m"
  }
  
  public struct Background {
    static let black  = "\u{001B}[40m"
    static let red    = "\u{001B}[41m"
    static let green  = "\u{001B}[42m"
    static let yellow = "\u{001B}[43m"
    static let blue   = "\u{001B}[44m"
    static let purple = "\u{001B}[45m"
    static let cyan   = "\u{001B}[46m"
    static let white  = "\u{001B}[47m"
  }
  
  public struct HighIntensity {
    static let black  = "\u{001B}[0;90m"
    static let red    = "\u{001B}[0;91m"
    static let green  = "\u{001B}[0;92m"
    static let yellow = "\u{001B}[0;93m"
    static let blue   = "\u{001B}[0;94m"
    static let purple = "\u{001B}[0;95m"
    static let cyan   = "\u{001B}[0;96m"
    static let white  = "\u{001B}[0;97m"
  }
  
  public struct BoldHighIntensity {
    static let black  = "\u{001B}[1;90m"
    static let red    = "\u{001B}[1;91m"
    static let green  = "\u{001B}[1;92m"
    static let yellow = "\u{001B}[1;93m"
    static let blue   = "\u{001B}[1;94m"
    static let purple = "\u{001B}[1;95m"
    static let cyan   = "\u{001B}[1;96m"
    static let white  = "\u{001B}[1;97m"
  }
  
  public struct HighIntensityBackground {
    static let black  = "\u{001B}[0;100m"
    static let red    = "\u{001B}[0;101m"
    static let green  = "\u{001B}[0;102m"
    static let yellow = "\u{001B}[0;103m"
    static let blue   = "\u{001B}[0;104m"
    static let purple = "\u{001B}[0;105m"
    static let cyan   = "\u{001B}[0;106m"
    static let white  = "\u{001B}[0;107m"
  }
}