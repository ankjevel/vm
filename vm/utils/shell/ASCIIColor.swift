//
//  ASCIIColor.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-17.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

public struct ASCIIColor {

  private static let u = "\u{001B}["

  static let reset = "\(u)0m"

  public struct Normal {
    static let black  = "\(u)0;30m"
    static let red    = "\(u)0;31m"
    static let green  = "\(u)0;32m"
    static let yellow = "\(u)0;33m"
    static let blue   = "\(u)0;34m"
    static let purple = "\(u)0;35m"
    static let cyan   = "\(u)0;36m"
    static let white  = "\(u)0;37m"
  }

  public struct Bold {
    static let black  = "\(u)1;30m"
    static let red    = "\(u)1;31m"
    static let green  = "\(u)1;32m"
    static let yellow = "\(u)1;33m"
    static let blue   = "\(u)1;34m"
    static let purple = "\(u)1;35m"
    static let cyan   = "\(u)1;36m"
    static let white  = "\(u)1;37m"
  }

  public struct Underline {
    static let black  = "\(u)4;30m"
    static let red    = "\(u)4;31m"
    static let green  = "\(u)4;32m"
    static let yellow = "\(u)4;33m"
    static let blue   = "\(u)4;34m"
    static let purple = "\(u)4;35m"
    static let cyan   = "\(u)4;36m"
    static let white  = "\(u)4;37m"
  }

  public struct Background {
    static let black  = "\(u)40m"
    static let red    = "\(u)41m"
    static let green  = "\(u)42m"
    static let yellow = "\(u)43m"
    static let blue   = "\(u)44m"
    static let purple = "\(u)45m"
    static let cyan   = "\(u)46m"
    static let white  = "\(u)47m"
  }

  public struct HighIntensity {
    static let black  = "\(u)0;90m"
    static let red    = "\(u)0;91m"
    static let green  = "\(u)0;92m"
    static let yellow = "\(u)0;93m"
    static let blue   = "\(u)0;94m"
    static let purple = "\(u)0;95m"
    static let cyan   = "\(u)0;96m"
    static let white  = "\(u)0;97m"
  }

  public struct BoldHighIntensity {
    static let black  = "\(u)1;90m"
    static let red    = "\(u)1;91m"
    static let green  = "\(u)1;92m"
    static let yellow = "\(u)1;93m"
    static let blue   = "\(u)1;94m"
    static let purple = "\(u)1;95m"
    static let cyan   = "\(u)1;96m"
    static let white  = "\(u)1;97m"
  }

  public struct HighIntensityBackground {
    static let black  = "\(u)0;100m"
    static let red    = "\(u)0;101m"
    static let green  = "\(u)0;102m"
    static let yellow = "\(u)0;103m"
    static let blue   = "\(u)0;104m"
    static let purple = "\(u)0;105m"
    static let cyan   = "\(u)0;106m"
    static let white  = "\(u)0;107m"
  }
}
