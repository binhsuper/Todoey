//
//  Item.swift
//  Todoey
//
//  Created by BinhHoang on 9/12/19.
//  Copyright © 2019 BinhHoang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
