//
//  Setting.swift
//  CareerUp
//
//  Created by Adam Emery on 10/10/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class Setting:NSObject {

    //info
    var name = "New Event"
    var date = NSDate()
    var details = "No Details Yet"
    
    //colors
    var iconBackgroundColor = UIColor.whiteColor()
    var backgroundColor = UIColor.lightGrayColor()
    var textColor = UIColor.whiteColor()
    var highlightColor = UIColor.orangeColor()
    
    // paging text
    var pagingText = ["test":"This is a test", "test 2":"this is another test"]
    
    //background type
    var backgroundType = "map"
    
    //images
    var icon = UIImage(named: "ec_logo_header.png")
    var backgroundImage:UIImage?
    
    
    //map details
    var address = "1934 Old Gallows Road Vienna, VA 22182"
}