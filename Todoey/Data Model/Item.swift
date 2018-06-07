//
//  Item.swift
//  Todoey
//
//  Created by James Naff on 5/27/18.
//  Copyright © 2018 James Naff. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    
    @objc dynamic var title = ""
    
    @objc dynamic var done = false
    
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
