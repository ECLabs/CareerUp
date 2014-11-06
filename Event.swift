class Event: NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    
    var editing = false
    
    var name = "New Event"
    var details = "No Details Yet"
    var date = NSDate()
    var setting = Setting()
}
