//
//  jobListingTable.swift
//  CareerUp
//
//  Created by Adam Emery on 10/31/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class JobListingTable: UITableViewController {
    var locations = LocationHandler.sharedInstance().locations
    var selectedIndex = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return locations.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations[section].jobs.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let location = locations[section]
        return "\(location.name) - \(location.city), \(location.state)"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let job = locations[indexPath.section].jobs[indexPath.row]
        

        cell.textLabel?.text = job.title
        return cell
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath
        return indexPath
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if let jobDetail = segue.destinationViewController as? JobDetails {
            let location = locations[selectedIndex.section]
            jobDetail.title = "\(location.name) - \(location.city), \(location.state)"
            
            jobDetail.job = location.jobs[selectedIndex.row]
        }
    }


}
