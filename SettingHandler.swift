//
//  SettingHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

var settingInstance: SettingHandler?

class SettingHandler: NSObject {
    class func sharedInstance() -> SettingHandler {
        if !(settingInstance != nil) {
            settingInstance = SettingHandler()
        }
        return settingInstance!
    }
    
    func get(objectId:String)->Setting {
        let settingQuery = PFQuery(className: "Setting")
        
        var error = NSErrorPointer()
        let settingObject = settingQuery.getObjectWithId(objectId, error: error)
        
        let setting = Setting()
        
        if error == nil {
            
            setting.objectId = settingObject.objectId
            setting.updatedAt = settingObject.updatedAt
            
            let backgroundColor: PFObject = settingObject["backgroundColor"] as PFObject
            let highlightColor: PFObject = settingObject["highlightColor"] as PFObject
            let logoColor: PFObject = settingObject["logoColor"] as PFObject
            let textColor: PFObject = settingObject["textColor"] as PFObject
            
            let colorHandler = ColorHandler.sharedInstance()
            let pageHandler = PageTextHandler.sharedInstance()

            setting.backgroundColor = colorHandler.get(backgroundColor.objectId)
            setting.highlightColor = colorHandler.get(highlightColor.objectId)
            setting.iconBackgroundColor = colorHandler.get(logoColor.objectId)
            setting.textColor = colorHandler.get(textColor.objectId)
            setting.pagingText = pageHandler.getAllForSetting(setting.objectId)
            
            
            if (settingObject["logo"]? != nil) {
                let logoFile:PFFile = settingObject["logo"] as PFFile
                
                
                let fileError = NSErrorPointer()
                let logoData = logoFile.getData(fileError)
                if error == nil {
                    setting.icon = UIImage(data: logoData)
                
                }
            }
        }
        return setting
    }
    
    
}

