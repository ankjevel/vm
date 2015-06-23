//
//  vmWare.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import AppKit

public class VMWare {
  
  private struct Paths {
    static let VMWARE_INSTALL_PATH = "/Applications/VMware Fusion.app"
    static let USER_INVENTORY_PATH = "~/Library/Application Support/VMware Fusion/vmInventory".stringByExpandingTildeInPath
    static let SHARED_INVENTORY_PATH = "/Library/Application Support/VMware/VMware Fusion/Shared/vmInventory"
    static let VMRUN_PATH = "\(Paths.VMWARE_INSTALL_PATH)/Contents/Library/vmrun"
  }
  
  init() {
    if NSFileManager().fileExistsAtPath(Paths.VMWARE_INSTALL_PATH) == false {
      halt("Missing: \(Paths.VMWARE_INSTALL_PATH), exiting")
    } else if NSFileManager().fileExistsAtPath(Paths.VMRUN_PATH) == false {
      halt("Missing: \(Paths.VMRUN_PATH), exiting")
    }
  }
}

// MARK: Public
public extension VMWare {

  var list: [VMConfig] {
    get {
      var inventory = inventoryList()
      updateStatus(&inventory)
      addInfo(&inventory)
      return inventory
    }
  }
  
  func start(inout selected: FeedbackItem) {
    println("\(ASCIIColor.Bold.green)Starting \(selected.title)\(ASCIIColor.reset)")
    let (_, error) = runAndPassError([
      "start",
      selected.id,
      "nogui"
    ])
    
    if error == "" {
      println("\(ASCIIColor.Bold.green)Started\(ASCIIColor.reset)")
      selected.running = true
    } else {
      println("\(ASCIIColor.Bold.red)Could not start\(ASCIIColor.reset)")
    }
  }
  
  func run(args: [String]) -> String {
    return shell(Paths.VMRUN_PATH, args)
  }
  
  func runAndPassError(args: [String]) -> (String, String) {
    return shell(Paths.VMRUN_PATH, true, args)
  }
}

// MARK: Private
private extension VMWare {

  func updateStatus(inout inventory: [VMConfig]) {
    var results = split(shell(Paths.VMRUN_PATH, ["list"])) {$0 == "\n"}
    for line in results {
      line.strip
      if line.hasPrefix("Total running VMs") == false {
        inventory
          .filter() {
            $0.path == line
          }
          .map() {
            $0.status = "Running"
          }
      }
    }
  }
  
  func addInfo(inout inventory: [VMConfig]) {
    inventory.map() { vmconfig -> VMConfig in
      if vmconfig.running {
        vmconfig.ipAddress = self.ipAddress(vmconfig.path)
      }
      if let guestOS = self.runtimeConfig(vmconfig.path, value: "guestOS") {
        vmconfig.os = guestOS
      }
      return vmconfig
    }
  }
  
  func inventoryList() -> [VMConfig] {
    var inventory: String? = nil
    let inventoryPath: String
    
    let fileManager = NSFileManager()
    
    if fileManager.fileExistsAtPath(Paths.USER_INVENTORY_PATH) {
      inventoryPath = Paths.USER_INVENTORY_PATH
    } else if fileManager.fileExistsAtPath(Paths.SHARED_INVENTORY_PATH) {
      inventoryPath = Paths.USER_INVENTORY_PATH
    } else {
      return []
    }
    
    inventory = NSString(data: fileManager.contentsAtPath(inventoryPath)!, encoding: NSUTF8StringEncoding) as? String
    
    if inventory == nil {
      return []
    }
    
    var vmList = [String: VMConfig]()
    
    let lines = split(inventory!) {$0 == "\n"}
    for line in lines {
      var parts = split(line) {$0 == "="}
      if parts.count == 2 {
        var lhs: String = parts[0].strip
        var rhs: String = parts[1].strip
        var tokens = split(lhs) {$0 == "."}
        if tokens.count == 2 && count(tokens[0]) > 0 {
          var id = tokens[0].strip
          var param = tokens[1].strip
          var vm: VMConfig
          if vmList[id] != nil {
            vm = vmList[id]!
          } else {
            vm = VMConfig()
            vmList[id] = vm
          }
          if param == "config" {
            vm.path = rhs.removeQuotations.strip
          } else if param == "DisplayName" {
            vm.name = rhs.removeQuotations.strip
          }
        }
      }
    }
    
    return vmList.values.array.filter() {
      $0.path != "" && count($0.path) > 0
    }
  }
  
  func runtimeConfig(path: String, value: String) -> String? {
    let fileManager = NSFileManager()
    
    if fileManager.fileExistsAtPath(path),
      let data = NSString(data: fileManager.contentsAtPath(path)!, encoding: NSUTF8StringEncoding) as? String {
      
        var lines = split(data) {$0 == "\n"}
        for line in lines {
          var parts = split(line) {$0 == "="}
          if parts.count == 2 {
            var lhs = parts[0].strip
            var rhs = parts[1].strip
            if lhs == value {
              return rhs.removeQuotations
            }
          }
        }
    }
    return nil
  }
  
  func ipAddress(vmPath: String) -> String {
    return shell(Paths.VMRUN_PATH, [
      "readVariable",
      vmPath,
      "guestVar",
      "ip"
    ]).strip
  }
}