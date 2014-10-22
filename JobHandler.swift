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
}
