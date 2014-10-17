//
//  SettingSelectTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/10/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class SettingSelectTableViewController: UITableViewController {
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
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.sharedInstance().localSettings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let setting = DataHandler.sharedInstance().localSettings[indexPath.row]
        
        cell.textLabel?.text = setting.name
        cell.detailTextLabel?.text = setting.details
        return cell

    }

    @IBAction func AddSettings(AnyObject) {
        let setting = Setting()
        setting.name = "New Event"
    
        DataHandler.sharedInstance().localSettings.append(setting)
        
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row as Int
        return indexPath
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
        let settingDetail: SettingsTableViewController = segue.destinationViewController as SettingsTableViewController
        let selectedSetting = DataHandler.sharedInstance().localSettings[selectedIndex]
        settingDetail.eventSetting = selectedSetting
    }
}
