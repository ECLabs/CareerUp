//
//  DataHandler.swift
//  CareerUp
//
//  Created by Adam Emery on 10/10/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

var instance: DataHandler?

class DataHandler: NSObject {
    var localApplicants:Array<Resume> = Array()
    var localSettings:Array<Setting> = Array()

    class func sharedInstance() -> DataHandler {
        if !(instance != nil) {
            instance = DataHandler()
        }
        return instance!
    }
}
