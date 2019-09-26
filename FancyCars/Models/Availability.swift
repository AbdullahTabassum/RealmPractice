//
//  Availability.swift
//  FancyCars
//
//  Created by Apple on 2019-09-25.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import Foundation
import RealmSwift

class Availability: Object, Codable {
    @objc dynamic var id = 0
    @objc dynamic var available = "Unavailable"
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
