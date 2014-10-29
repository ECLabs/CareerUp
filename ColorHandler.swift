//
//  ColorHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

var colorInstance: ColorHandler?

class ColorHandler: NSObject {

    class func sharedInstance() -> ColorHandler {
        if !(colorInstance != nil) {
            colorInstance = ColorHandler()
        }
        return colorInstance!
    }
    
    func get(objectId:String)->Color {
        let colorQuery = PFQuery(className: "Color")
        colorQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
        var error = NSErrorPointer()
        let colorObject = colorQuery.getObjectWithId(objectId, error: error)
        
        let color = Color()
        
        if error == nil {
            let red = colorObject["red"] as CGFloat
            let green = colorObject["green"] as CGFloat
            let blue = colorObject["blue"] as CGFloat
            let alpha = colorObject["alpha"] as CGFloat
            color.objectId = colorObject.objectId
            color.color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        return color
    }
}
