//
//  Resume.swift
//  CareerUp
//
//  Created by Adam Emery on 10/5/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class Candidate: NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    var modified = false
    var eventId = ""
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var jobTitle = ""
    var comments = ""
    var linkedIn = ""
    var resume:UIImage?
    var notes = ""
}
