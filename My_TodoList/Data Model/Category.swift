//
//  Category.swift
//  My_TodoList
//
//  Created by Aries Lam on 3/30/19.
//  Copyright © 2019 Cuong Tran. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
