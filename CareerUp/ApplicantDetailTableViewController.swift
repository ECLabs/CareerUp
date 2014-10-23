//
//  ApplicantDetailTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/13/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class ApplicantDetailTableViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet var firstName:UITextField?
    @IBOutlet var lastName:UITextField?
    @IBOutlet var email:UITextField?
    @IBOutlet var jobTitle:UITextField?
    @IBOutlet var linkedIn:UITextField?
    @IBOutlet var comments:UITextView?
    @IBOutlet var resume:UIImageView?
    @IBOutlet var notes:UITextView?
    
    var applicantResume:Candidate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstName?.text = applicantResume?.firstName
        lastName?.text = applicantResume?.lastName
        email?.text = applicantResume?.email
        jobTitle?.text = applicantResume?.jobTitle
        linkedIn?.text = applicantResume?.linkedIn
        comments?.text = applicantResume?.comments
        resume?.image = applicantResume?.resume
        notes?.text = applicantResume?.notes
        
        notes?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func textViewDidEndEditing(textView: UITextView) {
        applicantResume?.notes = textView.text
        
        CandidateHandler.sharedInstance().save(applicantResume!)
    }
}
