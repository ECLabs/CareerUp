//
//  Location.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class Location: NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    var modified = false
    
    var jobs:[Job] = []
    
    var name = "New Location"
    var address = ""
    var state = ""
    var city = ""
}
