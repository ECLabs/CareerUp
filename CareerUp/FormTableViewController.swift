//
//  FormTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/3/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var firstName:UITextField?
    @IBOutlet var lastName:UITextField?
    @IBOutlet var email:UITextField?
    @IBOutlet var jobTitle:UITextField?
    @IBOutlet var linkedIn:UITextField?
    @IBOutlet var comments:UITextView?
    @IBOutlet var resume:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelTapped(AnyObject) {
        println("hide form")
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func submitTapped(AnyObject) {
        if(email!.text.isEmpty) {
        
            self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
        
            let emailMissingAlert = UIAlertView(title: "Missing Required Field",
                                                message: "Please enter your email address before submitting",
                                                delegate: nil, cancelButtonTitle: "Ok")
            emailMissingAlert.show()
            
            
        } else { 
            let submission = Resume()
            submission.firstName = firstName!.text
            submission.lastName = lastName!.text
            submission.email = email!.text
            submission.linkedIn = linkedIn!.text
            submission.comments = comments!.text
            submission.resume = resume!.image
        }
    }
    
    
    @IBAction func cameraTapped(AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: {})
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        resume!.image = image
        
        picker.dismissViewControllerAnimated(true, completion: {})
    }
    
}

