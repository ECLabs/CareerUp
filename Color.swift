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
    
    func updateUIColor(){
        color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
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
    
    func getSaveDictionary()->NSDictionary {
        let dic = NSMutableDictionary()
        
        dic.setValue(objectId, forKey: "objectId")
        dic.setValue(red, forKey: "red")
        dic.setValue(green, forKey: "green")
        dic.setValue(blue, forKey: "blue")
        dic.setValue(alpha, forKey: "alpha")
        
        return dic
    }
    
    class func colorforDictonary(dic:NSDictionary)->Color {
        let newColor = Color()
        newColor.objectId = dic.objectForKey("objectId") as String
        newColor.red = dic.objectForKey("red") as CGFloat
        newColor.blue = dic.objectForKey("blue") as CGFloat
        newColor.green = dic.objectForKey("green") as CGFloat
        newColor.alpha = dic.objectForKey("alpha") as CGFloat
        newColor.updateUIColor()
        
        return newColor
    }
}
