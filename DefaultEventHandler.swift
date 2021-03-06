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
        defaultEvent.cachePolicy = kPFCachePolicyNetworkElseCache;
        var error = NSErrorPointer()
        let defaultObject = defaultEvent.getFirstObject(error)
        if error == nil && defaultObject != nil{
            self.defaultEvent.objectId = defaultObject.objectId
            
            if (defaultObject["event"]? != nil) {
                let eventObject = defaultObject["event"] as PFObject
                
                self.defaultEvent.event = EventHandler.sharedInstance().get(eventObject.objectId)
                
                
            }
        }
        return self.defaultEvent.event
    }
    
    func save(eventId:String){
        let submit = PFObject(className: "DefaultEvent")
        
        if !defaultEvent.objectId.isEmpty {
            submit.objectId = defaultEvent.objectId
        }
        submit["event"] = PFObject(withoutDataWithClassName: "Event", objectId: eventId)
        
        submit.saveInBackgroundWithBlock({(success, error) -> Void in
            if success {
                self.defaultEvent.objectId = submit.objectId
                println("uploadComplete")
            }
        })
    }
}
