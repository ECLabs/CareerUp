//
//  SettingsTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/6/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet var textColor:UIButton?
    @IBOutlet var backgroundColor:UIButton?
    @IBOutlet var highlightColor:UIButton?
    @IBOutlet var pageText:UITextView?
    @IBOutlet var logoImage:UIImageView?
    @IBOutlet var backgroundImage:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelTapped(AnyObject) {
        println("hide form")
        self.dismissViewControllerAnimated(true, completion: {})
    }

}
