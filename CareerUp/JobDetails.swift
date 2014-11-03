//
//  JobDetails.swift
//  CareerUp
//
//  Created by Adam Emery on 10/31/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class JobDetails: UITableViewController {
    @IBOutlet var jobTitle:UITextField?
    @IBOutlet var experiance:UITextField?
    @IBOutlet var customer:UITextField?
    @IBOutlet var details:UITextView?
    
    var job:Job?

    override func viewDidLoad() {
        super.viewDidLoad()

        jobTitle?.text = job?.title
        experiance?.text = job?.experianceLevel
        customer?.text = job?.customer
        details?.text = job?.details
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
