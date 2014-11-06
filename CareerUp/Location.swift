import MapKit

class Location: NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    
    var jobs:[Job] = []
    
    var name = "New Location"
    var address = ""
    var state = ""
    var city = ""
    var coordinate:CLLocationCoordinate2D?
}
