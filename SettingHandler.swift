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
        settingQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
        var error = NSErrorPointer()
        let settingObject = settingQuery.getObjectWithId(objectId, error: error)
        
        let setting = Setting()
        
        if error == nil {
            
            setting.objectId = settingObject.objectId
            setting.updatedAt = settingObject.updatedAt
            
            let colorHandler = ColorHandler.sharedInstance()
            let pageHandler = PageTextHandler.sharedInstance()
            
            if let bgUnwrap: PFObject = settingObject["backgroundColor"] as? PFObject{
                setting.backgroundColor = colorHandler.get(bgUnwrap.objectId)
            }
            if let hlUnwrap: PFObject = settingObject["highlightColor"] as? PFObject{
                setting.highlightColor = colorHandler.get(hlUnwrap.objectId)
            }
            if let logoUnwrap: PFObject = settingObject["logoColor"] as? PFObject{
                setting.iconBackgroundColor = colorHandler.get(logoUnwrap.objectId)
            }
            if let textUnwrap: PFObject = settingObject["textColor"] as? PFObject{
                setting.textColor = colorHandler.get(textUnwrap.objectId)
            }
            
            if let showMap = settingObject["showMap"] as? Bool{
                setting.hasMap = showMap
            }
            
            setting.pagingText = pageHandler.getAllForSetting(setting.objectId)
            
            
            if let logoFile:PFFile = settingObject["logo"] as? PFFile {
                let fileError = NSErrorPointer()
                let logoData = logoFile.getData(fileError)
                if error == nil {
                    if logoFile.name.lowercaseString.hasSuffix(".gif") {
                        setting.icon = UIImage.animatedImageWithAnimatedGIFData(logoData)
                    }
                    else {
                        setting.icon = UIImage(data: logoData)
                    }
                
                }
            }
            
            if let backgroundImageFile:PFFile = settingObject["backgroundImage"] as? PFFile {
                let fileError = NSErrorPointer()
                let backgroundImageData = backgroundImageFile.getData(fileError)
                if error == nil {
                    if backgroundImageFile.name.lowercaseString.hasSuffix(".gif") {
                         setting.backgroundImage = UIImage.animatedImageWithAnimatedGIFData(backgroundImageData)
                    }
                    else {
                        setting.backgroundImage = UIImage(data: backgroundImageData)
                    }
                   
                
                }
            }
        }
        return setting
    }
}
