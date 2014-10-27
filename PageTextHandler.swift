//
//  PageTextHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

var pageTextInstance: PageTextHandler?

class PageTextHandler: NSObject {
    class func sharedInstance() -> PageTextHandler {
        if !(pageTextInstance != nil) {
            pageTextInstance = PageTextHandler()
        }
        return pageTextInstance!
    }
   
    func getAllForSetting(settingObjectId:String)->[PageText] {
        let pagingQuery = PFQuery(className: "PageText")
        pagingQuery.whereKey("setting", equalTo: PFObject(withoutDataWithClassName: "Setting", objectId: settingObjectId))
        
        var error = NSErrorPointer()
        
        let objects = pagingQuery.findObjects(error)
        
        var pageTexts:[PageText] = []
        
        if error == nil {
            for object in objects{
                let page = PageText()
                page.objectId = object.objectId
                page.updatedAt = object.updatedAt
                
                if (object["title"]? != nil) {
                    page.title = object["title"] as String
                }
                if (object["content"]? != nil) {
                    page.content = object["content"] as String
                }
                pageTexts.append(page)
            }
        }
        
        return pageTexts
    }
    
    func save(submission:PageText, settingId:String){
        let page = PFObject(className: "PageText")
        
        if !submission.objectId.isEmpty{
            page.objectId = submission.objectId
        }
        page["title"] = submission.title
        page["content"] = submission.content
        
        page["setting"] = PFObject(withoutDataWithClassName: "Setting", objectId: settingId)

        page.saveInBackgroundWithBlock({(success, error) -> Void in
            if (error == nil) {
                println("uploadComplete")
            }
        })
    }
}
