//
//  DataHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/10/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse
var instance: DataHandler?

class DataHandler: NSObject {
    var localApplicants:[Resume] = []
    var localSettings:[Setting] = []
    var parseApplicants:[Resume] = []
    var parseSettings:[Setting] = []
    var applicantLoadingObjectCount = 0
    var settingLoadingObjectCount = 0
    var applicantsReloaded = false
    var settingsReloaded = false
    var defaultSetting:Setting?
    
    class func sharedInstance() -> DataHandler {
        if !(instance != nil) {
            instance = DataHandler()
        }
        return instance!
    }
    
    func getAplicants() {
        println("----- GETTING app ------")
        applicantLoadingObjectCount = -1
        self.parseApplicants.removeAll(keepCapacity: false)
        
        let query = PFQuery(className: "Candidate")
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error == nil) {
                self.applicantLoadingObjectCount = objects.count
                for object in objects {
                    let resume = Resume()
                
                    if (object["firstName"]? != nil) {
                        resume.firstName = object["firstName"] as String
                    }
                    if (object["lastName"]? != nil) {
                        resume.lastName = object["lastName"] as String
                    }
                    if (object["email"]? != nil) {
                        resume.email = object["email"] as String
                    }
                    if (object["desiredJobTitle"]? != nil) {
                        resume.jobTitle = object["desiredJobTitle"] as String
                    }
                    if (object["linkedInUrl"]? != nil) {
                        resume.linkedIn = object["linkedInUrl"] as String
                    }
                    if (object["comments"]? != nil) {
                        resume.comments = object["comments"] as String
                    }
                    if (object["notes"]? != nil) {
                        resume.notes = object["notes"] as String
                    }
                    
                    self.parseApplicants.append(resume)
                    
                    println("adding Object")
                    if (object["resumeImage"]? != nil) {
                        self.applicantLoadingObjectCount++
                        let userImageFile:PFFile = object["resumeImage"] as PFFile
                        
                        userImageFile.getDataInBackgroundWithBlock({(imageData, error) -> Void in
                            if (error == nil) {
                                let image = UIImage(data: imageData)
                                
                                resume.resume = image
                            }
                            self.applicantLoadingObjectCount--
                        })
                    }
                    self.applicantLoadingObjectCount--
                }
            }
            else{
                self.applicantLoadingObjectCount = 0
            }
        })
    }
    
    func getAplicantsCount() {
        let query:PFQuery = PFQuery(className: "Candidate")
        query.countObjectsInBackgroundWithBlock({(objectCount, error) -> Void in
            if (error == nil) {
                if Int(objectCount) != self.parseApplicants.count {
                    self.getAplicants()
                    self.applicantsReloaded = true
                }
            }
        })
    }
    
    func getEventsCount() {
        let query:PFQuery = PFQuery(className: "Event")
        query.countObjectsInBackgroundWithBlock({(objectCount, error) -> Void in
            if (error == nil) {
                if Int(objectCount) != self.localSettings.count {
                    self.getEvents()
                    self.settingsReloaded = true
                }
            }
        })
    }
    
    func submitResume(submission:Resume){
        let object = PFObject(className: "Candidate")
        
        object["firstName"] = submission.firstName
        object["lastName"] = submission.lastName
        object["email"] = submission.email
        object["desiredJobTitle"] = submission.jobTitle
        object["linkedInUrl"] = submission.linkedIn
        object["comments"] = submission.comments
        object["notes"] = submission.notes
        
        if (submission.resume != nil) {
            let imageData = UIImagePNGRepresentation(submission.resume)
            let imageFile = PFFile(name: "image.png", data: imageData)
            object["resumeImage"] = imageFile
        }
        
        object.saveInBackgroundWithBlock({(success, error) -> Void in
            if (error == nil) {
                println("uploadComplete")
            }
        })
    }
    
    
    
    func getEvents() {
        self.localSettings.removeAll(keepCapacity: false)
        settingLoadingObjectCount = -1
        let query = PFQuery(className: "Event")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.settingLoadingObjectCount = objects.count
                for object in objects {
                    let event = Setting()
                    if (object["name"]? != nil) {
                        event.name = object["name"] as String
                    }
                    if (object["description"]? != nil){
                        event.details = object["description"] as String
                    }
                    if (object["eventDate"]? != nil) {
                        event.date = object["eventDate"] as NSDate
                    }
                    
                    self.localSettings.append(event)
                    println("adding object")
                    self.settingLoadingObjectCount--
                    
                    if (object["setting"]? != nil){
                        let settingString: PFObject = object["setting"] as PFObject
                        let settingQuery = PFQuery(className: "Setting")
                        settingQuery.getObjectInBackgroundWithId(settingString.objectId, ({(settingObject: PFObject!, error)-> Void in
                            if error == nil {
                                let backgroundColor: PFObject = settingObject["backgroundColor"] as PFObject
                                let highlightColor: PFObject = settingObject["backgroundColor"] as PFObject
                                let logoColor: PFObject = settingObject["backgroundColor"] as PFObject
                                let textColor: PFObject = settingObject["backgroundColor"] as PFObject
                                
                                let backgroundColorQuery = PFQuery(className: "Color")
                                
                                backgroundColorQuery.getObjectInBackgroundWithId(backgroundColor.objectId, ({(object: PFObject!, error)-> Void in
                                    if error == nil {
                                        let red = object["red"] as CGFloat
                                        let green = object["green"] as CGFloat
                                        let blue = object["blue"] as CGFloat
                                        let alpha = object["alpha"] as CGFloat
                                        
                                        event.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                                        
                                    }
                                }))
                                
                                let highlightColorQuery = PFQuery(className: "Color")
                                highlightColorQuery.getObjectInBackgroundWithId(highlightColor.objectId, ({(object: PFObject!, error)-> Void in
                                    if error == nil {
                                        let red = object["red"] as CGFloat
                                        let green = object["green"] as CGFloat
                                        let blue = object["blue"] as CGFloat
                                        let alpha = object["alpha"] as CGFloat
                                        
                                        event.highlightColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                                        
                                    }
                                }))
                                
                                let logoColorQuery = PFQuery(className: "Color")
                                logoColorQuery.getObjectInBackgroundWithId(logoColor.objectId, ({(object: PFObject!, error)-> Void in
                                    if error == nil {
                                        let red = object["red"] as CGFloat
                                        let green = object["green"] as CGFloat
                                        let blue = object["blue"] as CGFloat
                                        let alpha = object["alpha"] as CGFloat
                                        
                                        event.iconBackgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                                        
                                    }
                                }))
                                
                                let textColorQuery = PFQuery(className: "Color")
                                textColorQuery.getObjectInBackgroundWithId(textColor.objectId, ({(object: PFObject!, error)-> Void in
                                    if error == nil {
                                        let red = object["red"] as CGFloat
                                        let green = object["green"] as CGFloat
                                        let blue = object["blue"] as CGFloat
                                        let alpha = object["alpha"] as CGFloat
                                        
                                        event.textColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                                        
                                    }
                                }))
                                
                            }
                        }))
                    }
                }
            }
        })
    }
}
