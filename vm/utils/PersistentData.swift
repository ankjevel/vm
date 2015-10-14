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
    static let folder: String = NSString(string: "~/Library/Application Support/vm/").stringByExpandingTildeInPath
    static let file = NSURL(fileURLWithPath: folder).URLByAppendingPathComponent("vm.storedata")
  }
  
  var hasChanges = false
  
  private let fm = NSFileManager()
  
  lazy var file: [String: Setting] = {
    if self.fm.fileExistsAtPath(Paths.folder) == false {
      do {
        try self.fm.createDirectoryAtPath(Paths.folder, withIntermediateDirectories: true, attributes: nil)
      } catch _ {
      }
    }
    
    let path = Paths.file
    var parsed = [String: Setting]()
    if
      let data = NSData(contentsOfURL: path),
      let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? NSDictionary {
        for top in json.enumerate() {
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
    
    for f in self.file.enumerate() {
      let _ = f.element.0
      let val = f.element.1
      description[f.element.0] = val.describe()
    }
    
    if let data = try? NSJSONSerialization.dataWithJSONObject(description, options: .PrettyPrinted) {
      data.writeToFile(Paths.file.absoluteString, atomically: false)
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
    for dict in self.file.enumerate() {
      let s = dict.element.1
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
    
    if context.count > 0 {
      results = Array(context.values)
    } else {
      results = []
    }
    return results
  }
  
  func saveEntity(fb: FeedbackItem) {
    let setting = Setting(
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
    let pdc = self.persistentDataContext
    if pdc.hasChanges {
      pdc.save()
    }
  }
}

private extension PersistentData {
}