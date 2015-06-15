//
//  StringsTests.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-15.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Cocoa
import XCTest

class StringsTests: XCTestCase {

  override
  func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override
  func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testStrip() {
    XCTAssertEqual(" foo bar ".strip, "foo bar", "Strips tabs")
  }
  
  func testStripNewLine() {
    XCTAssertEqual("foo\n".stripNewLine, "foo", "Strips new line")
  }
  
  func testContains() {
    XCTAssertTrue("foo bar baz".contains("bar"), "Contains \"bar\"")
    XCTAssertTrue("foo BAR baz".contains("bar"), "Contains \"bar\", ignored casing")
    XCTAssertTrue("foo BAR baz".contains("BAR"), "Contains \"bar\", ignored casing in both assert and string")
    XCTAssertFalse("foo baz".contains("bar"), "Does not contain \"bar\"")
  }
}
