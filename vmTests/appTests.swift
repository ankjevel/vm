//
//  appTests.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-15.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Cocoa
import XCTest

class mockApp: App {

  override var generate: (Feedback, [VMConfig]) {
    get {
      return (Feedback(), [])
    }
  }
}

class appTests: XCTestCase {
  
  var app = mockApp()
  
  override func setUp() {
    super.setUp()
    app = mockApp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testMsBuild() {
    XCTAssertTrue(true, "should be true")
  }

}
