//
//  msbuild.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-18.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public struct MSBuild {
  private let vmware: VMWare
  
  init (inout vmware: VMWare) {
    self.vmware = vmware
  }
}

// MARK: Public
public extension MSBuild {
  
  func run(selected: FeedbackItem) {
    println(vmware.runAndPassError([
      "-gu \"\(selected.options.user)\"",
      "-gp \"\(selected.options.password)\"",
      "fileExistsInGuest \(selected.id) \"\(selected.options.solution.removeQuotations)\""]))
    //
//    println(vmware.run("\(cred) fileExistsInGuest \"\(selected.id)\" \"\(selected.options.solution.removeQuotations)\""))
//    println(vmware.run("fileExistsInGuest \(selected.options.solution.removeQuotations)"))
  }
}

// MARK: Private
private extension MSBuild {

}