//
//  Keychain.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-21.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import AppKit
import Security

public class Keychain {

  private var pIdentifier = ""

  public var identifier: String {
    get {
      return pIdentifier
    }
    set (value) {
      pIdentifier = value.stripWhiteSpaceAndNewLine
    }
  }

}

public extension Keychain {

  func save(key: String, data: String) -> Bool {
    let query = [
      kSecClass as String: kSecClassGenericPassword as String,
      kSecAttrAccount as String: "\(identifier)@\(key)",
      kSecValueData as String: data.dataUsingEncoding(NSUTF8StringEncoding)!
    ]

    SecItemDelete(query as CFDictionaryRef)

    let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)

    return status == noErr
  }

  func load(key: String) -> String? {
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: "\(identifier)@\(key)",
      kSecReturnData as String: kCFBooleanTrue,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var result: AnyObject?

    let status = withUnsafeMutablePointer(&result) {
      SecItemCopyMatching(query, UnsafeMutablePointer($0))
    }

    if status == noErr,
      let resultUnwrapped = result as? NSData,
      let data = NSString(data: resultUnwrapped, encoding: NSUTF8StringEncoding) {
      return data as String
    } else {
      return nil
    }
  }

  func delete(key: String) -> Bool {
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: "\(identifier)@\(key)"
    ]

    let status: OSStatus = SecItemDelete(query as CFDictionaryRef)

    return status == noErr
  }

  func clear() -> Bool {
    let query = [
      kSecClass as String: kSecClassGenericPassword
    ]

    let status: OSStatus = SecItemDelete(query as CFDictionaryRef)

    return status == noErr
  }

}
