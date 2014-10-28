//
//  AppDelegate.swift
//  CareerUp
//
//  Created by Adam Emery on 9/30/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

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

