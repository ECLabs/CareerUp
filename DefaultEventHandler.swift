//
//  DefaultEventHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

var defaultInstance: DefaultEventHandler?

class DefaultEventHandler: NSObject {
    var defaultEvent = DefaultEvent()
    
    class func sharedInstance() -> DefaultEventHandler {
        if !(defaultInstance != nil) {
            defaultInstance = DefaultEventHandler()
        }
        return defaultInstance!
    }
    
    func get()->Event{
        let defaultEvent = PFQuery(className: "DefaultEvent")
        var error = NSErrorPointer()
        let defaultObject = defaultEvent.getFirstObject(error)
        if error == nil {
            self.defaultEvent.objectId = defaultObject.objectId
            self.defaultEvent.updatedAt = defaultObject.updatedAt
            
            if (defaultObject["event"]? != nil) {
                let eventObject = defaultObject["event"] as PFObject
                
                self.defaultEvent.event = EventHandler.sharedInstance().get(eventObject.objectId)
                
                
            }
        }
        return self.defaultEvent.event
    }
    
    func save(eventId:String){
        let submit = PFObject(className: "DefaultEvent")
        submit.objectId = defaultEvent.objectId
        submit["event"] = PFObject(withoutDataWithClassName: "Event", objectId: eventId)
        
        submit.saveInBackgroundWithBlock({(success, error) -> Void in
            if (error == nil) {
                println("uploadComplete")
            }
        })
    }
}
