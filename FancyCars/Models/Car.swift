//
//  Car.swift
//  FancyCars
//
//  Created by Apple on 2019-09-25.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import Foundation
import RealmSwift

class Car: Object, Codable {
    @objc dynamic var id = 0
    
    @objc dynamic var img = "-"
    @objc dynamic var name = "-"
    @objc dynamic var make = "-"
    @objc dynamic var model = "-"
    @objc dynamic var year = 1900
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
