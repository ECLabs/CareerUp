//
//  Setting.swift
//  CareerUp
//
//  Created by Adam Emery on 10/10/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

class Setting:NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    var modified = false
    
    //colors
    var iconBackgroundColor = Color()
    var backgroundColor = Color()
    var textColor = Color()
    var highlightColor = Color()
    
    // paging text
    var pagingText:[PageText] = []
    
    //background type
    var backgroundType = "map"
    
    //images
    var icon:UIImage?
    var backgroundImage:UIImage?
    
    func prepareForParse()->PFObject {
        let setting = PFObject(className: "Setting")
        
        if !self.objectId.isEmpty{
            setting.objectId = self.objectId
        }
        
        setting["textColor"] = self.textColor.prepareForParse()
        setting["backgroundColor"] = self.backgroundColor.prepareForParse()
        setting["logoColor"] = self.iconBackgroundColor.prepareForParse()
        setting["highlightColor"] = self.highlightColor.prepareForParse()
        
        if (self.icon != nil) {
            let imageData = UIImagePNGRepresentation(self.icon)
            let imageFile = PFFile(name: "image.png", data: imageData)
            setting["logo"] = imageFile
        }
        if (self.backgroundImage != nil) {
            let imageData = UIImagePNGRepresentation(self.backgroundImage)
            let imageFile = PFFile(name: "background.png", data: imageData)
            setting["backgroundImage"] = imageFile
        }
    
        
        
        return setting
    }
}