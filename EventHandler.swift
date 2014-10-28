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
    var localEvents:[Event] = []
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
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.loadingCount = objects.count
                for object in objects {
                    let event = self.parseEvent(object as PFObject)
                    self.events.append(event)
                    self.loadingCount--
                }
            }
        })
    }
    
    func get(objectId:String)->Event{
        let query = PFQuery(className: "Event")
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        var error = NSErrorPointer()
        let object = query.getObjectWithId(objectId, error: error)
        
        var event = Event()
        
        println(error)
        if error == nil {
            event = self.parseEvent(object as PFObject)
        }
        return event
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
    
    func parseEvent(object:PFObject)->Event {
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
        
        if (object["setting"]? != nil){
        
            let settingString: PFObject = object["setting"] as PFObject
            let setting = SettingHandler.sharedInstance().get(settingString.objectId)
            event.setting = setting
        }
        
        return event
    }
    
    func save(submission:Event){
        let event = PFObject(className: "Event")
        
        if !submission.objectId.isEmpty{
            event.objectId = submission.objectId
        }
        event["name"] = submission.name
        event["eventDate"] = submission.date
        event["description"] = submission.details
        
        event["setting"] = submission.setting.prepareForParse()
        
        event.saveInBackgroundWithBlock({(success, error) -> Void in
            if success {
                println("uploadComplete")
                
                for page in submission.setting.pagingText {
                    PageTextHandler.sharedInstance().save(page, settingId: submission.setting.objectId)
                }
            }
        })
    }
    
    
    
}
