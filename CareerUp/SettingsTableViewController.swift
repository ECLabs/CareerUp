//
//  SettingsTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/6/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {
    var eventSetting:Event?
    var selectedPicker:String?
    var dateDisplay:NSDate?
    var pagingItems:[PageText]?
    
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
        
        let setting = eventSetting?.setting
        textColor?.backgroundColor = setting?.textColor?.color
        backgroundColor?.backgroundColor = setting?.backgroundColor?.color
        logobackgroundColor?.backgroundColor = setting?.iconBackgroundColor?.color
        highlightColor?.backgroundColor = setting?.highlightColor?.color
        
        //paging text
        var text:String?
        
        
        if (setting? != nil) {
            text = "\(setting!.pagingText.count) Paging Text Items"
        }
        else {
            text = "0 Paging Text Items"
        }
        pageText?.textLabel?.text = text

        pagingItems = setting?.pagingText
        
        //images
        logoImage?.image = setting?.icon
        backgroundImage?.image = setting?.backgroundImage
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
        eventSetting?.date = dateDisplay!
        
        let setting = eventSetting?.setting
        setting?.textColor?.color = textColor!.backgroundColor!
        setting?.backgroundColor?.color = backgroundColor!.backgroundColor!
        setting?.iconBackgroundColor?.color = logobackgroundColor!.backgroundColor!
        setting?.highlightColor?.color = highlightColor!.backgroundColor!
        setting?.pagingText = pagingItems!
        setting?.icon = logoImage!.image!
        setting?.backgroundImage = backgroundImage?.image!
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
