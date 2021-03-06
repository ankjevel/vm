//
//  app.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-15.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation

public class App: PersistentData {

  private var vmware = VMWare()
  private let keychain = Keychain()
  private let build: MSBuild

  override init() {
    self.build = MSBuild(vmware: &self.vmware)
    super.init()

    if main.ClearSaveData {
      clearSaveData()
    }
  }
}

// MARK: Public
public extension App {

  func msBuild(options: MSBuildOptions = MSBuildOptions()) {
    let gen = generate
    let fb = gen.0
    for vm in gen.1 {
      if vm.os.contains("windows") == false {
        continue
      }
      var ok = false
      if main.VMImage != nil {
        ok = vm.name.contains(main.VMImage!)
      } else {
        ok = true
      }
      if ok {
        fb.addItem(FeedbackItem(
          title: vm.name,
          id: vm.path,
          running: vm.running
        ))
      }
    }

    if fb.items.count == 0 {
      halt("no vms available", 100)
    }

    //  if fb.items.count > 1 {
    var selected = getImage(fb, options: options)
    keychain.identifier = selected.id

    let entity: [Setting] = getEntities().filter() {
      $0.id == selected.id
    }

    var loaded: Bool = false
    let entityExists = entity.count > 0

    if entityExists,
      let last = entity.last {
        promptLoad(last, selected: &selected, loaded: &loaded)
    }

    setUser(&selected, loaded: &loaded)
    setPassword(&selected, loaded: &loaded)
    setSolution(&selected, loaded: &loaded)
    setTask(&selected, loaded: &loaded)
    setTaskProperty(&selected, loaded: &loaded)

    build.selected = selected
    build.run() {
      self.saveEntity(selected)
    }
  }

}

// MARK: Private
private extension App {

  func emp(string: String) -> String {
    let b = ASCIIColor.Bold.white
    let r = ASCIIColor.reset
    return "\(b)\(string)\(r)"
  }

  func setUserAndPassword(user: String, inout selected: FeedbackItem) {
    if let password = keychain.load(user) as String? {
      selected.options.password.value = password
    }
    selected.options.user.value = user
  }

  func promptLoad(setting: Setting, inout selected: FeedbackItem, inout loaded: Bool) {
    var loadProfile: Bool? = nil

    if main.Answer != nil {
      loadProfile = main.Answer!
    }

    while loadProfile == nil {
      let help = emp("yes|no")
      let input = getUserInput("load user profile (\(help))?")
      if input != "" {
        loadProfile = input.bool
      }
    }

    if loadProfile == true {
      var user: String? = nil

      if selected.options.user.set {
        user = selected.options.user.value
      } else if setting.user != "" {
        user = setting.user
      }

      if let unwrapped = user {
        setUserAndPassword(unwrapped, selected: &selected)
      }
      if selected.options.solution.set == false {
        selected.options.solution.value = setting.solution
      }
      if selected.options.task.set == false {
        selected.options.task.value = setting.task
      }
      if selected.options.property.set == false {
        selected.options.property.value = setting.property
      }
      loaded = true
    }
  }

  func getImage(fb: Feedback, options: MSBuildOptions) -> FeedbackItem {

    var item: FeedbackItem?

    if main.VMImage != nil {
      if let element = fb.items.filter({ $0.title.contains(main.VMImage!) }).first {
        item = element
        item!.options = options
      }
    }

    if item == nil {
      if fb.items.count == 1 {
        item = fb.items.first!
        item!.options = options
      } else {
        var index = -1
        let range = fb.items.startIndex ... fb.items.endIndex - 1
        var message = "select image (index):"
        for e in fb.items.enumerate() {
          let status = e.element.running == true ? "(running)" : "(stopped)"
          message  += "\n[\(e.index)] \(e.element.title) \(status)"

          repeat {
            let input = getUserInput(message)
            if input != "", let unwrapped = Int(input) {
              index = unwrapped
            }
          } while (range ~= index) == false

          item = fb.items[index]
          item!.options = options
        }
      }
    }

    if item!.running == false {
      var userInput: Bool? = main.Answer
      while userInput == nil {
        let help = emp("yes|no")
        let input = getUserInput("vm is stopped, would you like to start it (\(help))?")
        if input != "" {
          userInput = input.bool
        }
      }
      if userInput == true {
        vmware.start(&item!)
      }

      if item!.running == false {
        halt("vm is stopped", 101, item!.title)
      }
    }

    return item!
  }

  func setUser(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.user.set == false {
      let help = emp("ex: COMPANY\\user")
      let input = getUserInput("select user (\(help)):")
      selected.options.user.value = input
      loaded = false
    }
  }

  func setSolution(inout selected: FeedbackItem, inout loaded: Bool) {

    let help = emp("ex: C:\\dev\\Project\\Project.sln")
    let message = "path to solution file (\(help)):"

    while selected.options.solution.set == false {
      var input = getUserInput(message)
      if input.hasPrefix("~") {
        input = NSString(string: input).stringByExpandingTildeInPath
      }
      selected.options.solution.value = input
      loaded = false
    }
  }

  func setTask(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.task.set == false {
      let help = emp("ex: /t:build")
      let input = getUserInput("select msbuild task (\(help)):")
      selected.options.task.value = input
      loaded = false
    }
  }

  func setTaskProperty(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.property.set == false {
      let help = emp("ex: /property:Configuration=Debug")
      let input = getUserInput("select msbuild task propert(y|ies) (\(help)):")
      selected.options.property.value = input
      loaded = false
    }
  }

  func setPassword(inout selected: FeedbackItem, inout loaded: Bool) {
    while selected.options.password.set == false {
      let input = getUserInput("password for \(selected.options.user.value):", noEcho: true)
      selected.options.password.value = input
      loaded = false
    }
    savePassword(selected.options)
  }

  func savePassword(options: MSBuildOptions) {
    keychain.save(options.user.value, data: options.password.value)
  }

  func clearSaveData() {

    var userInput: Bool? = main.Answer

    while userInput == nil {
      let help = emp("yes|no")
      let input = getUserInput("do you really want to clear previosly saved data (\(help))?")
      if input != "" {
        userInput = input.bool
      }
    }

    if userInput == true {
      let context = persistentDataContext
      context.file.removeAll(keepCapacity: false)

      saveContext()
    }
  }

  var generate: (Feedback, [VMConfig]) {
    get {
      return (Feedback(), vmware.list)
    }
  }
}
