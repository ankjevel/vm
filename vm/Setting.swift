//
//  Setting.swift
//  
//
//  Created by Dennis Pettersson on 2015-06-21.
//
//

import Foundation
import CoreData

class Setting: NSManagedObject {

    @NSManaged var id: String?
    @NSManaged var property: String?
    @NSManaged var solution: String?
    @NSManaged var task: String?
    @NSManaged var user: String?

}
