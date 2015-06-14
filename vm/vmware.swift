//
//  vmware.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-13.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import AppKit

@objc public
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
      line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
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
    
    
    var vmList: [VMConfig] = []
    
    var lines = split(inventory!) {$0 == "\n"}
    for line in lines {
      println("line: \(line)")
      var parts = split(line) {$0 == "="}
      if parts.count == 2 {
        var lhs: String = parts[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var rhs: String = parts[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var tokens = split(lhs) {$0 == "."}
        if tokens.count == 2 && count(tokens[0]) > 0 {
          
        }
      }
    }
    
    
    var vm = VMConfig()
    vm.path = "hello"
    return [vm]
  }
  
  //  def inventory_list
  //    inventory_path = File.expand_path(USER_INVENTORY_PATH)
  //    unless File.exists?(inventory_path)
  //      inventory_path = File.expand_path(SHARED_INVENTORY_PATH)
  //    end
  //    inventory = File.open(inventory_path)
  //
  //    vmlist = {}
  //    inventory.each_line do |line|
  //      parts = line.split("=")
  //      if parts.length == 2f
  //        lhs = parts[0].strip
  //        rhs = parts[1].strip
  //        tokens = lhs.split(".")
  //        if tokens.length == 2 && tokens[0].length > 0
  //          id = tokens[0].strip
  //          param = tokens[1].strip
  //          vm = vmlist[id]
  //          if vm.nil?
  //            vm = VMConfig.new
  //            vmlist[id] = vm
  //          end
  //          if param == "config"
  //            vm.path = remove_quotations(rhs).strip
  //          elsif param == "DisplayName"
  //            vm.name = remove_quotations(rhs).strip
  //          end
  //        end
  //      end
  //    end
  //    vmlist.values.find_all {|item| item.path && item.path.length > 0}
  //  end
  
  private
  func runtimeConfig(path: String, value: String) -> String? {
    if let file = NSBundle.mainBundle().pathForResource(path, ofType: "vmx"), data = String(contentsOfFile: file, encoding: NSUTF8StringEncoding, error: nil) {
      var lines = split(data) {$0 == "\n"}
      for line in lines {
        var parts = split(line) {$0 == "="}
        if parts.count == 2 {
          var lhs = parts[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
          var rhs = parts[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
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
    return shell(VMRUN_PATH, "readVariable \(vmPath) guestVar ip")
      .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
  
  init() {
    VMRUN_PATH = "\(VMWARE_INSTALL_PATH)/Contents/Library/vmrun"
  }
}
