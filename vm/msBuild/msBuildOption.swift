//
//  msBuildOption.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-22.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public struct MSBuildOption {

  private var pValue: String
  private var pValidate: (value: String) -> Bool
  private let pIdentifier: String

  var value: String {
    get {
      return pValue
    }
    set (newValue) {
      if pValidate(value: newValue) {
        pValue = newValue
        set = true
      } else {
        print("\(ASCIIColor.Bold.red)invalid value for \(pIdentifier): \(newValue)\(ASCIIColor.reset)")
      }

    }
  }

  var set: Bool

  init(_ value: String, _ identifier: String, _ validation: (value: String) -> Bool) {
    self.pIdentifier = identifier
    self.pValue = value
    self.pValidate = validation
    self.set = value != ""
  }
}
