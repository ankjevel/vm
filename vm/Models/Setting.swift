//
//  Setting.swift
//  
//
//  Created by Dennis Pettersson on 2015-06-21.
//
//

import Foundation

public class Setting: Printable {
  
  var id: String
  var property: String
  var solution: String
  var task: String
  var user: String
  
  init(id: String, property: String, solution: String, task: String, user: String) {
    self.id = id
    self.property = property
    self.solution = solution
    self.task = task
    self.user = user
  }
}


public extension Setting {
  
  func describe() -> [String: AnyObject] {
    var description: [String: AnyObject] = [
      "id": id,
      "property": property,
      "solution": solution,
      "task": task,
      "user": user
    ]
    return description
  }
  var description: String {
    get {
      if
        let data = NSJSONSerialization.dataWithJSONObject(describe(), options: .PrettyPrinted, error: nil),
        let json = NSString(data: data, encoding: NSUTF8StringEncoding) {
          return json as String
      } else {
        return ""
      }
    }
  }
  
}