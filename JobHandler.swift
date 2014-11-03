//
//  JobHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/22/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

var jobInstance: JobHandler?


class JobHandler: NSObject {
    class func sharedInstance() -> JobHandler {
        if !(jobInstance != nil) {
            jobInstance = JobHandler()
        }
        return jobInstance!
    }
    
    func getAllForLocation(locationObjectId:String)->[Job] {
        let pagingQuery = PFQuery(className: "Job")
        pagingQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
        pagingQuery.whereKey("location", equalTo: PFObject(withoutDataWithClassName: "Location", objectId: locationObjectId))
        
        var error = NSErrorPointer()
        
        let objects = pagingQuery.findObjects(error)
        
        var jobs:[Job] = []
        
        if error == nil {
            for object in objects{
                let job = Job()
                job.objectId = object.objectId
                job.updatedAt = object.updatedAt
                
                if (object["jobTitle"]? != nil) {
                    job.title = object["jobTitle"] as String
                }
                if (object["experianceLevel"]? != nil) {
                    job.experianceLevel = object["experianceLevel"] as String
                }
                if (object["customer"]? != nil) {
                    job.customer = object["customer"] as String
                }
                if (object["description"]? != nil) {
                    job.details = object["description"] as String
                }
                jobs.append(job)
            }
        }
        
        return jobs
    }
}
