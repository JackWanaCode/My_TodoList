//
//  Item.swift
//  My_TodoList
//
//  Created by Aries Lam on 3/30/19.
//  Copyright © 2019 Cuong Tran. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var voiceURL: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
