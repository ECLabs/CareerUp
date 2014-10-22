//
//  EventHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

var eventInstance: EventHandler?

class EventHandler: NSObject {
    var events:[Event] = []
    var loadingCount = 0
    var reloaded = false
    
    class func sharedInstance() -> EventHandler {
        if !(eventInstance != nil) {
            eventInstance = EventHandler()
        }
        return eventInstance!
    }
    
    func get() {
        self.events.removeAll(keepCapacity: false)
        loadingCount = -1
        let query = PFQuery(className: "Event")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.loadingCount = objects.count
                for object in objects {
                    let event = Event()
                    event.objectId = object.objectId
                    event.updatedAt = object.updatedAt
                    
                    if (object["name"]? != nil) {
                        event.name = object["name"] as String
                    }
                    if (object["description"]? != nil){
                        event.details = object["description"] as String
                    }
                    if (object["eventDate"]? != nil) {
                        event.date = object["eventDate"] as NSDate
                    }
                    
                    self.events.append(event)
                    println("adding object")
                    self.loadingCount--
                    
                    if (object["setting"]? != nil){
                    
                        let settingString: PFObject = object["setting"] as PFObject
                        let settingQuery = PFQuery(className: "Setting")
                        settingQuery.getObjectInBackgroundWithId(settingString.objectId, ({(settingObject: PFObject!, error)-> Void in
                            if error == nil {
                                let setting = Setting()
                                
                                setting.objectId = settingObject.objectId
                                setting.updatedAt = settingObject.updatedAt
                                
                                let backgroundColor: PFObject = settingObject["backgroundColor"] as PFObject
                                let highlightColor: PFObject = settingObject["backgroundColor"] as PFObject
                                let logoColor: PFObject = settingObject["backgroundColor"] as PFObject
                                let textColor: PFObject = settingObject["backgroundColor"] as PFObject
                                
                                let backgroundColorQuery = PFQuery(className: "Color")
                                
                                backgroundColorQuery.getObjectInBackgroundWithId(backgroundColor.objectId, ({(object: PFObject!, error)-> Void in
                                    if error == nil {
                                        let color = Color()
                                        
                                        color.objectId = object.objectId
                                        color.updatedAt = object.updatedAt
                                        
                                        let red = object["red"] as CGFloat
                                        let green = object["green"] as CGFloat
                                        let blue = object["blue"] as CGFloat
                                        let alpha = object["alpha"] as CGFloat
                                        color.color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                                        
                                        setting.backgroundColor = color
                                        
                                    }
                                }))
                                
                                let highlightColorQuery = PFQuery(className: "Color")
                                highlightColorQuery.getObjectInBackgroundWithId(highlightColor.objectId, ({(object: PFObject!, error)-> Void in
                                    if error == nil {
                                        let color = Color()
                                    
                                        let red = object["red"] as CGFloat
                                        let green = object["green"] as CGFloat
                                        let blue = object["blue"] as CGFloat
                                        let alpha = object["alpha"] as CGFloat
                                        color.color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                                        
                                        setting.highlightColor = color
                                    }
                                }))
                                
                                let logoColorQuery = PFQuery(className: "Color")
                                logoColorQuery.getObjectInBackgroundWithId(logoColor.objectId, ({(object: PFObject!, error)-> Void in
                                    if error == nil {
                                        let color = Color()
                                        
                                        let red = object["red"] as CGFloat
                                        let green = object["green"] as CGFloat
                                        let blue = object["blue"] as CGFloat
                                        let alpha = object["alpha"] as CGFloat
                                        color.color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                                        
                                        setting.iconBackgroundColor = color
                                    }
                                }))
                                
                                let textColorQuery = PFQuery(className: "Color")
                                textColorQuery.getObjectInBackgroundWithId(textColor.objectId, ({(object: PFObject!, error)-> Void in
                                    if error == nil {
                                        let color = Color()
                                        
                                        let red = object["red"] as CGFloat
                                        let green = object["green"] as CGFloat
                                        let blue = object["blue"] as CGFloat
                                        let alpha = object["alpha"] as CGFloat
                                        color.color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                            
                                        setting.textColor = color
                                    }
                                }))
                                
                                let pagingQuery = PFQuery(className: "PageText")
                                pagingQuery.whereKey("setting", equalTo: PFObject(withoutDataWithClassName: "Setting", objectId: setting.objectId))
                                
                                pagingQuery.findObjectsInBackgroundWithBlock({ (pagingObjects: [AnyObject]!, error: NSError!) -> Void in
                                    if error == nil {
                                        for pageObject in pagingObjects {
                                            let page = PageText()
                                            page.objectId = pageObject.objectId
                                            page.updatedAt = pageObject.updatedAt
                                            
                                            if (pageObject["title"]? != nil) {
                                                page.title = pageObject["title"] as String
                                            }
                                            if (pageObject["content"]? != nil) {
                                                page.content = pageObject["content"] as String
                                            }
                                            
                                            setting.pagingText.append(page)
                                        }
                                    }
                                })
                                event.setting = setting
                            }
                        }))
                    }
                }
            }
        })
    }
    
    func count() {
        let query:PFQuery = PFQuery(className: "Event")
        query.countObjectsInBackgroundWithBlock({(objectCount, error) -> Void in
            if (error == nil) {
                if Int(objectCount) != self.events.count {
                    self.get()
                    self.reloaded = true
                }
            }
        })
    }
}
