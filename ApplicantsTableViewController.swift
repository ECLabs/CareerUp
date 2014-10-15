//
//  ApplicantsTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/10/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class ApplicantsTableViewController: UITableViewController {
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.sharedInstance().localApplicants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resumeCell", forIndexPath: indexPath) as UITableViewCell
        
        let resume = DataHandler.sharedInstance().localApplicants[indexPath.row]
        
        cell.textLabel?.text = resume.email
        cell.detailTextLabel?.text = resume.firstName! + " " + resume.lastName!
        cell.imageView?.image = resume.resume
        return cell

    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row as Int
        println("setting index")
        
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
       let applicantDetail: ApplicantDetailTableViewController = segue.destinationViewController as ApplicantDetailTableViewController
        
        let selectedResume = DataHandler.sharedInstance().localApplicants[selectedIndex]
        applicantDetail.applicantResume = selectedResume
        
        applicantDetail.title = selectedResume.email
    }


}
