//
//  LocationHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

var locationInstance: LocationHandler?

class LocationHandler: NSObject {
    class func sharedInstance() -> LocationHandler {
        if !(locationInstance != nil) {
            locationInstance = LocationHandler()
        }
        return locationInstance!
    }
}
