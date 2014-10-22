//
//  CandidateHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

var candidateInstance: CandidateHandler?

class CandidateHandler: NSObject {
    var candidates:[Candidate] = []
    var loadingCount = 0
    var reloaded = false
    
    class func sharedInstance() -> CandidateHandler {
        if !(candidateInstance != nil) {
            candidateInstance = CandidateHandler()
        }
        return candidateInstance!
    }
    
    func get() {
        loadingCount = -1
        
        // need to change to compare to loaded objects
        self.candidates.removeAll(keepCapacity: false)

        let query = PFQuery(className: "Candidate")
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error == nil) {
                self.loadingCount = objects.count
                for object in objects {
                    let resume = Candidate()
                
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
                    
                    self.candidates.append(resume)
                    
                    println("adding Object")
                    if (object["resumeImage"]? != nil) {
                        self.loadingCount++
                        let userImageFile:PFFile = object["resumeImage"] as PFFile
                        
                        userImageFile.getDataInBackgroundWithBlock({(imageData, error) -> Void in
                            if (error == nil) {
                                let image = UIImage(data: imageData)
                                
                                resume.resume = image
                            }
                            self.loadingCount--
                        })
                    }
                    self.loadingCount--
                }
            }
            else{
                self.loadingCount = 0
            }
        })
    }
    
    func count() {
        let query:PFQuery = PFQuery(className: "Candidate")
        query.countObjectsInBackgroundWithBlock({(objectCount, error) -> Void in
            if (error == nil) {
                if Int(objectCount) != self.candidates.count {
                    self.get()
                    self.reloaded = true
                }
            }
        })
    }
    
    func put(submission:Candidate){
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
