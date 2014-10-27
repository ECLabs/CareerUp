//
//  PagingTextSelect.swift
//  CareerUp
//
//  Created by Adam Emery on 10/27/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class PagingTextSelect: UITableViewController {
    var activeSetting:Setting?
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func AddPage(AnyObject) {
        let page = PageText()
        activeSetting?.pagingText.append(page)
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return activeSetting!.pagingText.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        let page = activeSetting?.pagingText[indexPath.row]
        cell.textLabel?.text = page?.title
        cell.detailTextLabel?.text = page?.content

        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }


    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if let pageDetails = segue.destinationViewController as? PagingTextDetails {
            pageDetails.title = "Page"
            pageDetails.activeSetting = activeSetting
            pageDetails.pageIndex = selectedIndex
        }
    }
    

}
