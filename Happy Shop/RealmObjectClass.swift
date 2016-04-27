//
//  RealmObjectClass.swift
//  Happy Shop
//
//  Created by Dhiraj Jadhao on 26/04/16.
//  Copyright © 2016 Dhiraj Jadhao. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Product: RLMObject {

    dynamic var productIndex:Int = 0
    dynamic var productName:String!
    dynamic var productImageURL:String!
    dynamic var productUnits:Int = 0
    dynamic var productUnitPrice:Float = 0.00
    dynamic var productPriceForTotalUnits:Float = 0.00
    dynamic var onSale:Bool = false
    
    override static func primaryKey() -> String {
        return "productIndex"
    }
}
