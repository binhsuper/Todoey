//
//  Category.swift
//  Todoey
//
//  Created by BinhHoang on 9/12/19.
//  Copyright © 2019 BinhHoang. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
 }
