//
//  VM.swift
//  vm
//
//  Created by Dennis Pettersson on 2015-06-16.
//  Copyright (c) 2015 dennisp.se. All rights reserved.
//

import Foundation
import CoreData

class VM: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var property: String
    @NSManaged var solution: String
    @NSManaged var task: String
    @NSManaged var username: String

}
