//
//  Event.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class Event: NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    var modified = false
    
    var editing = false
    
    var name = "New Event"
    var details = "No Details Yet"
    var date = NSDate()
    var setting = Setting()
}
