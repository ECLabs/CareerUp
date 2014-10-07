//
//  ApplicantsTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/7/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class ApplicantsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelTapped(AnyObject) {
        println("hide form")
        self.dismissViewControllerAnimated(true, completion: {})
    }
}
