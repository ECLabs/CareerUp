//
//  SettingsTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/6/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {
    var eventSetting:Setting?
    var selectedPicker:String?
    var dateDisplay:NSDate?
    var pagingText:[String:String]?
    
    //info
    @IBOutlet var nameField:UITextField?
    @IBOutlet var detailsField:UITextField?
    @IBOutlet var dateField:UIButton?
    
    //colors
    @IBOutlet var textColor:UIButton?
    @IBOutlet var backgroundColor:UIButton?
    @IBOutlet var logobackgroundColor:UIButton?
    @IBOutlet var highlightColor:UIButton?
    
    //text
    @IBOutlet var pageText:UITableViewCell?
    //images
    
    @IBOutlet var logoImage:UIImageView?
    @IBOutlet var backgroundImage:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = eventSetting?.name
        
        // set info fields
        nameField?.text = eventSetting?.name
        detailsField?.text = eventSetting?.details
        
        dateDisplay = eventSetting?.date
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateField?.setTitle(dateFormater.stringFromDate(dateDisplay!), forState: UIControlState.Normal)
        
        textColor?.backgroundColor = eventSetting?.textColor
        backgroundColor?.backgroundColor = eventSetting?.backgroundColor
        logobackgroundColor?.backgroundColor = eventSetting?.iconBackgroundColor
        highlightColor?.backgroundColor = eventSetting?.highlightColor
        
        //paging text
        pageText?.textLabel?.text =  "\(eventSetting!.pagingText.count) Paging Text Items"
        pagingText = eventSetting?.pagingText

        //images
        logoImage?.image = eventSetting?.icon
        backgroundImage?.image = eventSetting?.backgroundImage
    }
    
    func createPhotoActionSheet(){
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
    
    @IBAction func cameraLogoTapped(AnyObject) {
        selectedPicker = "logo"
        createPhotoActionSheet()
    }
    
    @IBAction func cameraBackgroundTapped(AnyObject) {
        selectedPicker = "background"
        createPhotoActionSheet()
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
        if selectedPicker == "logo" {
            logoImage?.image = image
        }
        else if selectedPicker == "background" {
            backgroundImage?.image = image
        }
        
        picker.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func applyTapped(AnyObject) {
        eventSetting?.name = nameField!.text
        eventSetting?.details = detailsField!.text
        eventSetting?.date = dateDisplay
        eventSetting?.textColor = textColor!.backgroundColor!
        eventSetting?.backgroundColor = backgroundColor!.backgroundColor!
        eventSetting?.iconBackgroundColor = logobackgroundColor!.backgroundColor!
        eventSetting?.highlightColor = highlightColor!.backgroundColor!
        eventSetting?.pagingText = pagingText!
        eventSetting?.icon = logoImage!.image!
        eventSetting?.backgroundImage = backgroundImage?.image!
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
