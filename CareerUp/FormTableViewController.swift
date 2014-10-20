//
//  FormTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/3/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate
{
    @IBOutlet var firstName:UITextField?
    @IBOutlet var lastName:UITextField?
    @IBOutlet var email:UITextField?
    @IBOutlet var jobTitle:UITextField?
    @IBOutlet var linkedIn:UITextField?
    @IBOutlet var comments:UITextView?
    @IBOutlet var resume:UIImageView?
    @IBOutlet var emailCell:UITableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelTapped(AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func submitTapped(AnyObject) {
        if(!validateEmail(email!.text)) {
        
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
            submission.jobTitle = jobTitle!.text
            submission.resume = resume?.image
            
            DataHandler.sharedInstance().localApplicants.append(submission)
            
            println(DataHandler.sharedInstance().localApplicants)
            
            DataHandler.sharedInstance().submitResume(submission)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    @IBAction func cameraTapped(AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            let actionSheet = UIActionSheet()
            actionSheet.addButtonWithTitle("Camera")
            actionSheet.addButtonWithTitle("Photo Library")
            actionSheet.addButtonWithTitle("Cancel")
            actionSheet.cancelButtonIndex = 2
            actionSheet.showInView(self.view)
            actionSheet.delegate = self
        }
        else {
            usePhotoLibrary()
        }
    }
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            usePhotoLibrary()
        }
        else if buttonIndex == 0 {
            useCamera()
        }
    }
    
    func usePhotoLibrary(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: {})
    
    }
    
    func useCamera(){
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
    
    @IBAction func emailChanged() {
        if(validateEmail(email!.text)){
            emailCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            emailCell?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    
    func validateEmail(email:String)->Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

        let range = NSMakeRange(0, countElements(email))

        let regex = NSRegularExpression(pattern: emailRegex, options: nil, error: nil)

        let matches = regex.matchesInString(email, options: NSMatchingOptions.ReportProgress, range: range)
        return (matches.count > 0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println(validateEmail(email!.text))
        if !validateEmail(email!.text){
            let destination = segue.destinationViewController as ThankYouViewController
            destination.hide = true
        }
    }
    
}

