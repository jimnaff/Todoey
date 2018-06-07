//
//  Category.swift
//  Todoey
//
//  Created by James Naff on 5/27/18.
//  Copyright © 2018 James Naff. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    
    let items = List<Item>()
}
