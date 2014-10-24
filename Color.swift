//
//  Color.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

class Color: NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    var modified = false
    
    var red:CGFloat = 1
    var green:CGFloat = 1
    var blue:CGFloat = 1
    var alpha:CGFloat = 1
    
    var color:UIColor = UIColor.blackColor()
    
    
    func convert(colorIn:UIColor){
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        colorIn.getRed(&self.red, green: &self.green, blue: &self.blue, alpha: &self.alpha)
        
        self.color = colorIn
    }
    
    
    func prepareForParse()->PFObject {
        let color = PFObject(className: "Color")
        
        if !self.objectId.isEmpty{
            color.objectId = self.objectId
        }
        
        color["red"] = self.red
        color["green"] = self.green
        color["blue"] = self.blue
        color["alpha"] = self.alpha
        
        return color
    }
}
