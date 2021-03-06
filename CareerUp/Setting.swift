import Parse

class Setting:NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    
    //colors
    var iconBackgroundColor = Color()
    var backgroundColor = Color()
    var textColor = Color()
    var highlightColor = Color()
    
    // paging text
    var pagingText:[PageText] = []
    
    //background type
    var hasMap = false
    
    //images
    var icon:UIImage?
    var backgroundImage:UIImage?
    
    func prepareForParse()->PFObject {
        let setting = PFObject(className: "Setting")
        
        if !self.objectId.isEmpty{
            setting.objectId = self.objectId
        }
        
        setting["textColor"] = self.textColor.prepareForParse()
        setting["backgroundColor"] = self.backgroundColor.prepareForParse()
        setting["logoColor"] = self.iconBackgroundColor.prepareForParse()
        setting["highlightColor"] = self.highlightColor.prepareForParse()
        setting["showMap"] = self.hasMap
        
        if (self.icon != nil) {
            
            if self.icon?.duration > 0 {
                let imageData = self.icon?.getGIFdata()
                let imageFile = PFFile(name: "image.gif", data: imageData)
                setting["logo"] = imageFile
            
            }
            else {
                let imageData = UIImagePNGRepresentation(self.icon)
                let imageFile = PFFile(name: "image.png", data: imageData)
                setting["logo"] = imageFile
            }
        }
        else {
            setting["logo"] = NSNull()
        }
        if (self.backgroundImage != nil) {
        
            if self.backgroundImage?.duration > 0 {
                let imageData = self.backgroundImage?.getGIFdata()
                let imageFile = PFFile(name: "background.gif", data: imageData)
                setting["backgroundImage"] = imageFile
            
            }
            else {
                let imageData = UIImagePNGRepresentation(self.backgroundImage)
                let imageFile = PFFile(name: "background.png", data: imageData)
                setting["backgroundImage"] = imageFile
            }
        }
        else {
            setting["backgroundImage"] = NSNull()
        }
        return setting
    }
}