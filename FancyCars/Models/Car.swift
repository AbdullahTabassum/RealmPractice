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
    @objc dynamic var availability: Availability? = Availability()
    
    override class func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case img
        case name
        case make
        case model
        case year
    }
}
