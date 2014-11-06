import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("C0M2x71mmJo5iYXdSXC1lJSxnRgXP4Fx9efq5Pwg", clientKey: "F8mPqhEL30XRtkvuQv7uGNZ0gtwsf4Sbh2eamdr3")
        
        
        let paths:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths.objectAtIndex(0) as String
        let filePath = documentsDirectory + "candidates.ar"
        
        if(NSFileManager.defaultManager().fileExistsAtPath(filePath)){
            let canidateArray = NSArray(contentsOfFile: filePath)
            
            let localCandidates = CandidateHandler.sharedInstance().localCandidates
            for dic in canidateArray{
                let canidateDictonary = dic as NSDictionary
                let saved = Candidate()
                
                saved.objectId = canidateDictonary.objectForKey("objectId") as String
                saved.email = canidateDictonary.objectForKey("email") as String
                saved.lastName = canidateDictonary.objectForKey("lastName") as String
                saved.firstName = canidateDictonary.objectForKey("firstName") as String
                saved.comments = canidateDictonary.objectForKey("comments") as String
                saved.jobTitle = canidateDictonary.objectForKey("jobTitle") as String
                saved.linkedIn = canidateDictonary.objectForKey("linkedIn") as String
                
                
                let imageCount = canidateDictonary.objectForKey("imageCount") as String
                var range = 0...imageCount.toInt()!-1
                for i in range {
                    let imagePath = documentsDirectory + "\(saved.email)-\(i).png"
                    if(NSFileManager.defaultManager().fileExistsAtPath(imagePath)){
                        let imageData = NSData(contentsOfFile: imagePath)
                        
                        let image = UIImage(data: imageData)
                        
                        saved.resumeImages.append(image)
                    }
                    NSFileManager.defaultManager().removeItemAtPath(imagePath, error: nil)
                }
                
                
                CandidateHandler.sharedInstance().localCandidates.append(saved)
                CandidateHandler.sharedInstance().resave()
                
            }
            NSFileManager.defaultManager().removeItemAtPath(filePath, error: nil)
        }
        
        let eventFilePath = documentsDirectory + "events.ar"
        
        
        if(NSFileManager.defaultManager().fileExistsAtPath(eventFilePath)){
            let eventArray = NSArray(contentsOfFile: eventFilePath)
            
            println(eventArray)
            let localEvents = EventHandler.sharedInstance().localEvents
            
            for dic in eventArray{
                let eventDictonary = dic as NSDictionary
                let saved = Event()
                
                saved.objectId = eventDictonary.objectForKey("objectId") as String
                saved.name = eventDictonary.objectForKey("name") as String
                saved.date = eventDictonary.objectForKey("eventDate") as NSDate
                saved.details = eventDictonary.objectForKey("description") as String
                
                let savedSetting = Setting()
                
                let settingDictonary = eventDictonary.objectForKey("setting") as NSDictionary
                savedSetting.objectId = settingDictonary.objectForKey("objectId") as String
                savedSetting.hasMap = settingDictonary.objectForKey("hasMap") as Bool
                
                
                if settingDictonary.objectForKey("logo") as Bool {
                    let logoPath = documentsDirectory + "\(saved.name)-logo"
                    let imageData = NSData(contentsOfFile: logoPath)
                    let image = UIImage.animatedImageWithAnimatedGIFData(imageData)
                    savedSetting.icon = image
                
                }
                
                if settingDictonary.objectForKey("background") as Bool {
                    let backgroundPath = documentsDirectory + "\(saved.name)-background"
                    let imageData = NSData(contentsOfFile: backgroundPath)
                    let image = UIImage.animatedImageWithAnimatedGIFData(imageData)
                    savedSetting.backgroundImage = image
                }
                
                if let iconBackgroundDictonary = settingDictonary.objectForKey("iconBackgroundColor") as? NSDictionary {
                    savedSetting.iconBackgroundColor = Color.colorforDictonary(iconBackgroundDictonary)
                }
                if let backgroundDictonary = settingDictonary.objectForKey("backgroundColor") as? NSDictionary {
                    savedSetting.backgroundColor = Color.colorforDictonary(backgroundDictonary)
                }
                if let textDictonary = settingDictonary.objectForKey("textColor") as? NSDictionary {
                    savedSetting.textColor = Color.colorforDictonary(textDictonary)
                }
                if let highlightDictonary = settingDictonary.objectForKey("highlightColor") as? NSDictionary {
                    savedSetting.highlightColor = Color.colorforDictonary(highlightDictonary)
                }
                
                
                if let pageTextArray = settingDictonary.objectForKey("pageTexts") as? NSArray {
                    for aPage in pageTextArray {
                        let pageDic = aPage as NSDictionary
                        let savedPage = PageText()
                        savedPage.objectId = pageDic.objectForKey("objectId") as String
                        savedPage.title = pageDic.objectForKey("title") as String
                        savedPage.content = pageDic.objectForKey("content") as String
                        savedSetting.pagingText.append(savedPage)
                    }
                }
                
                saved.setting = savedSetting
                
                
                EventHandler.sharedInstance().localEvents.append(saved)
                EventHandler.sharedInstance().resave()
                
            }
            NSFileManager.defaultManager().removeItemAtPath(eventFilePath, error: nil)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let paths:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths.objectAtIndex(0) as String
        let filePath = documentsDirectory + "candidates.ar"
        
        
        let localCandidates = CandidateHandler.sharedInstance().localCandidates
        var allCanidates = NSMutableArray()
        for candidate in localCandidates {
            var canidateDic = NSMutableDictionary()
            canidateDic.setValue(candidate.objectId, forKey: "objectId")
            canidateDic.setValue(candidate.email, forKey: "email")
            canidateDic.setValue(candidate.lastName, forKey: "lastName")
            canidateDic.setValue(candidate.firstName, forKey: "firstName")
            canidateDic.setValue(candidate.comments, forKey: "comments")
            canidateDic.setValue(candidate.jobTitle, forKey: "jobTitle")
            canidateDic.setValue(candidate.linkedIn, forKey: "linkedIn")
            
            canidateDic.setValue("\(candidate.resumeImages.count)", forKey: "imageCount")

            for (index,image) in enumerate(candidate.resumeImages) {
                let imageData = UIImagePNGRepresentation(image)
                let imagePath = documentsDirectory + "\(candidate.email)-\(index).png"
                imageData.writeToFile(imagePath, atomically: true)
            }
            
            allCanidates.addObject(canidateDic)
        }
        
        allCanidates.writeToFile(filePath, atomically: true)
        
        
        //save events
        let eventFilePath = documentsDirectory + "events.ar"
        
        let localEvents = EventHandler.sharedInstance().localEvents
        var allEvents = NSMutableArray()
        for event in localEvents {
            var eventDic = NSMutableDictionary()
            eventDic.setValue(event.objectId, forKey: "objectId")
            eventDic.setValue(event.name, forKey: "name")
            eventDic.setValue(event.date, forKey: "eventDate")
            eventDic.setValue(event.details, forKey: "description")
            
            
            
            //save setting
            var settingDic = NSMutableDictionary()
            settingDic.setValue(event.setting.objectId, forKey: "objectId")
            settingDic.setValue(event.setting.hasMap, forKey: "hasMap")
            
            
            let settingImagePath = documentsDirectory + "\(event.name)-"
            
            if let logo = event.setting.icon {
            
                let logoPath = settingImagePath + "logo"
                
                if logo.duration > 0 {
                    let imageData = logo.getGIFdata()
                    imageData.writeToFile(logoPath, atomically: true)
                }
                else {
                    let imageData = UIImagePNGRepresentation(logo)
                    imageData.writeToFile(logoPath, atomically: true)
                }
                settingDic.setValue(true, forKey: "logo")
            }
            else {
                settingDic.setValue(false, forKey: "logo")
            }
            
            if let backgroundImage = event.setting.backgroundImage {
                            
                let backgroundPath = settingImagePath + "background"
                
                if backgroundImage.duration > 0 {
                    let imageData = backgroundImage.getGIFdata()
                    imageData.writeToFile(backgroundPath, atomically: true)
                }
                else {
                    let imageData = UIImagePNGRepresentation(backgroundImage)
                    imageData.writeToFile(backgroundPath, atomically: true)
                }
                settingDic.setValue(true, forKey: "background")
            }
            else {
                settingDic.setValue(false, forKey: "background")
            }
            
            var pageArray = NSMutableArray()
            for page in event.setting.pagingText {
                var pageDic = NSMutableDictionary()
                pageDic.setValue(page.objectId, forKey: "objectId")
                pageDic.setValue(page.title, forKey: "title")
                pageDic.setValue(page.content, forKey: "content")
                pageArray.addObject(pageDic)
            }
            
            settingDic.setValue(pageArray, forKey: "pageTexts")
            
            settingDic.setValue(event.setting.iconBackgroundColor.getSaveDictionary(), forKey: "iconBackgroundColor")
            settingDic.setValue(event.setting.backgroundColor.getSaveDictionary(), forKey: "backgroundColor")
            settingDic.setValue(event.setting.textColor.getSaveDictionary(), forKey: "textColor")
            settingDic.setValue(event.setting.highlightColor.getSaveDictionary(), forKey: "highlightColor")
            
            eventDic.setValue(settingDic, forKey: "setting")
            allEvents.addObject(eventDic)
        }
        allEvents.writeToFile(eventFilePath, atomically: true)
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {

        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

