//
//  vmware.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import AppKit

public
class VMWare {
  
  private
  let VMWARE_INSTALL_PATH = "/Applications/VMware Fusion.app",
      USER_INVENTORY_PATH = "~/Library/Application Support/VMware Fusion/vmInventory".stringByExpandingTildeInPath,
      SHARED_INVENTORY_PATH = "/Library/Application Support/VMware/VMware Fusion/Shared/vmInventory",
      VMRUN_PATH: String
  
  public
  func run(cmd: AnyObject...) -> String {
    return shell(VMRUN_PATH, cmd)
  }
  
  public
  var list: [VMConfig] {
    get {
      var inventory = inventoryList()
      updateStatus(&inventory)
      addInfo(&inventory)
      return inventory
    }
  }
  
  private
  func updateStatus(inout inventory: [VMConfig]) {
    var results = split(shell(VMRUN_PATH, "list")) {$0 == "\n"}
    for line in results {
      line.strip
      if line.hasPrefix("Total running VMs") == false {
        inventory
          .filter({
            $0.path == line
          })
          .map({
            $0.status = "Running"
          })
      }
    }
  }
  
  private
  func addInfo(inout inventory: [VMConfig]) {
    inventory.map({ vmconfig -> VMConfig in
      if vmconfig.running {
        vmconfig.ipAddress = self.ipAddress(vmconfig.path)
      }
      if let guestOS = self.runtimeConfig(vmconfig.path, value: "guestOS") {
        vmconfig.os = guestOS
      }
      return vmconfig
    })
  }
  
  private
  func inventoryList() -> [VMConfig] {
    var inventory: String? = nil
    let inventoryPath: String
    
    let fileManager = NSFileManager()
    
    if fileManager.fileExistsAtPath(USER_INVENTORY_PATH) {
      inventoryPath = USER_INVENTORY_PATH
    } else if fileManager.fileExistsAtPath(SHARED_INVENTORY_PATH) {
      inventoryPath = USER_INVENTORY_PATH
    } else {
      return []
    }
    
    inventory = NSString(data: fileManager.contentsAtPath(inventoryPath)!, encoding: NSUTF8StringEncoding) as? String
    
    if inventory == nil {
      return []
    }
    
    
    var vmList = [String: VMConfig]()
    
    var lines = split(inventory!) {$0 == "\n"}
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
            vm.path = removeQuotations(rhs).strip
          } else if param == "DisplayName" {
            vm.name = removeQuotations(rhs).strip
          }
        }
      }
    }
    
    return vmList.values.array.filter({
      $0.path != "" && count($0.path) > 0
    })
  }
  
  private
  func runtimeConfig(path: String, value: String) -> String? {
    if let file = NSBundle.mainBundle().pathForResource(path, ofType: "vmx"), data = String(contentsOfFile: file, encoding: NSUTF8StringEncoding, error: nil) {
      var lines = split(data) {$0 == "\n"}
      for line in lines {
        var parts = split(line) {$0 == "="}
        if parts.count == 2 {
          var lhs = parts[0].strip
          var rhs = parts[1].strip
          if lhs == value {
            return removeQuotations(rhs)
          }
        }
      }
    }
    return nil
  }
  
  private
  func removeQuotations(string: String) -> String {
    var modifiedString = string
    if string.hasPrefix("\"") {
      modifiedString = dropFirst(string)
    }
    if string.hasSuffix("\"") {
      modifiedString = dropLast(modifiedString)
    }
    return modifiedString
  }
  
  private
  func ipAddress(vmPath: String) -> String {
    return shell(VMRUN_PATH, "readVariable \(vmPath) guestVar ip").strip
  }
  
  init() {
    VMRUN_PATH = "\(VMWARE_INSTALL_PATH)/Contents/Library/vmrun"
  }
}
