//
//  PersistentData
//  vm
//
//  Created by Dennis Pettersson on 2015-06-26.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

internal class JSON {
  
  internal struct Paths {
    static let folder = "~/Library/Application Support/vm/".stringByExpandingTildeInPath
    static let file = folder.stringByAppendingPathComponent("vm.storedata")
  }
  
  var hasChanges = false
  
  private let fm = NSFileManager()
  
  lazy var file: [String: Setting] = {
    
    if self.fm.fileExistsAtPath(Paths.folder) == false {
      self.fm.createDirectoryAtPath(Paths.folder, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
    
    let path = Paths.file
    var parsed = [String: Setting]()
    
    if
      let data = NSData(contentsOfFile: path),
      let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
        
        for top in enumerate(json) {
          if
            let key = top.element.key as? String,
            let value = top.element.value as? Dictionary<String, AnyObject> {
              var setting: Setting? = nil
              if
                let id = value["id"] as? String,
                let property = value["property"] as? String,
                let solution = value["solution"] as? String,
                let task = value["task"] as? String,
                let user = value["user"] as? String {
                  setting = Setting(
                    id: id,
                    property: property,
                    solution: solution,
                    task: task,
                    user: user
                  )
              }
              
              if setting != nil {
                parsed[key] = setting
              }
          }
        }
        return parsed
    } else {
      return [String: Setting]()
    }
    
    }()
  
  func save() {
    var description = [String: [String: AnyObject]]()
    
    for f in enumerate(self.file) {
      let key = f.element.0
      let val = f.element.1
      description[f.element.0] = val.describe()
    }
    
    if let data = NSJSONSerialization.dataWithJSONObject(description, options: .PrettyPrinted, error: nil) {
      data.writeToFile(Paths.file, atomically: false)
    }
  }
  
  func update(setting: Setting) {
    if doesntExist(setting) {
      hasChanges = true
      self.file[setting.id] = setting
    }
  }
}

private extension JSON {
    
  func doesntExist(setting: Setting) -> Bool {
    var changes = true
    for dict in enumerate(self.file) {
      var s = dict.element.1
      if s.id == setting.id {
        if s.property != setting.property ||
          s.solution != setting.solution ||
          s.task != setting.task ||
          s.user != setting.user {
            return true
        } else {
          changes = false
        }
      }
    }
    return changes
    
  }
}

public class PersistentData {
  
  let persistentDataContext = JSON()
  
  func getEntities() -> [Setting] {
    let results: [Setting]
  
    let context = persistentDataContext.file
    
    if count(context) > 0 {
      results = context.values.array
    } else {
      results = []
    }
    return results
  }
  
  func saveEntity(fb: FeedbackItem) {
    
    var setting = Setting(
      id: fb.id,
      property: fb.options.property.value,
      solution: fb.options.solution.value,
      task: fb.options.task.value,
      user: fb.options.user.value
    )
    
    persistentDataContext.update(setting)
    
    saveContext()
  }
  
  func saveContext() {
    var pdc = self.persistentDataContext
    if pdc.hasChanges {
      pdc.save()
    }
  }
}

private extension PersistentData {
}