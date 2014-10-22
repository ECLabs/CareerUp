//
//  Setting.swift
//  CareerUp
//
//  Created by Adam Emery on 10/10/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class Setting:NSObject {
    var objectId = ""
    var updatedAt:NSDate?
    var modified = false
    
    //colors
    var iconBackgroundColor:Color?
    var backgroundColor:Color?
    var textColor:Color?
    var highlightColor:Color?
    
    // paging text
    var pagingText:[PageText] = []
    
    //background type
    var backgroundType = "map"
    
    //images
    var icon = UIImage(named: "ec_logo_header.png")
    var backgroundImage:UIImage?
    
    //map details
    var address = "1934 Old Gallows Road Vienna, VA 22182"
}