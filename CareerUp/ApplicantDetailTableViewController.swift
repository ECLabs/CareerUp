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
    @IBOutlet var resume:UITableViewCell?
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
        //resume?.image = applicantResume?.resumeImages
        
        
        if applicantResume?.pdfData == nil {
            resume?.textLabel?.text = "No Attached Resume"
            resume?.userInteractionEnabled = false
            resume?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        notes?.text = applicantResume?.notes
        
        notes?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        applicantResume?.editing = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        applicantResume?.editing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        println("hello test")
//        if applicantResume?.pdfData == nil {
//            return false
//        }
//        return true
//    }
//    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let resumeView: ResumeViewer = segue.destinationViewController as ResumeViewer
        resumeView.imageData = applicantResume?.pdfData
    }


    func textViewDidEndEditing(textView: UITextView) {
        applicantResume?.notes = textView.text
        
        CandidateHandler.sharedInstance().save(applicantResume!)
    }
}
