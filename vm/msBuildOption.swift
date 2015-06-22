//
//  msBuildOption.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-22.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public struct MSBuildOption {
  
  private var _value: String
  private var _validate: (value: String) -> Bool
  private let _identifier: String
  
  var value: String {
    get {
      return _value
    }
    set (newValue) {
      if _validate(value: newValue) {
        _value = newValue
        set = true
      }
      
    }
  }
  
  var set: Bool
  
  init(_ value: String, _ identifier: String, _ validation: (value: String) -> Bool) {
    self._identifier = identifier
    self._value = value
    self._validate = validation
    self.set = value != ""
  }
}