import Parse

var locationInstance: LocationHandler?

class LocationHandler: NSObject {
    var locations:[Location] = []
    var loadingCount = 0
    var reloaded = false
    
    class func sharedInstance() -> LocationHandler {
        if !(locationInstance != nil) {
            locationInstance = LocationHandler()
        }
        return locationInstance!
    }
    
    func get() {
        self.locations.removeAll(keepCapacity: false)
        loadingCount = -1
        
        let query = PFQuery(className: "Location")
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.loadingCount = objects.count
                for object in objects {
                    let location = self.parseLocation(object as PFObject)
                    self.locations.append(location)
                    self.loadingCount--
                }
            }
        })
    }
    
    func parseLocation(object:PFObject)->Location {
        let location = Location()
        location.objectId = object.objectId
        location.updatedAt = object.updatedAt
        
        if (object["name"]? != nil) {
            location.name = object["name"] as String
        }
        if (object["address"]? != nil){
            location.address = object["address"] as String
        }
        if (object["state"]? != nil) {
            location.state = object["state"] as String
        }
        if (object["city"]? != nil) {
            location.city = object["city"] as String
        }
        
        location.jobs = JobHandler.sharedInstance().getAllForLocation(location.objectId)
        return location
    }
}
