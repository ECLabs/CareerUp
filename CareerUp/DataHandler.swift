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
    var applicantLoadingObjectCount = 0
    class func sharedInstance() -> DataHandler {
        if !(instance != nil) {
            instance = DataHandler()
        }
        return instance!
    }
    
    func getAplicants() {
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
}
