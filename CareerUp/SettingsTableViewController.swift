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
    var pagingItems:[PageText]?
    
    //info
    @IBOutlet var nameField:UITextField?
    @IBOutlet var detailsField:UITextField?
    @IBOutlet var dateField:UIDatePicker?
    
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
        
        dateField?.setDate(eventSetting!.date, animated: false)
        
        let setting = eventSetting?.setting
        textColor?.backgroundColor = setting?.textColor.color
        backgroundColor?.backgroundColor = setting?.backgroundColor.color
        logobackgroundColor?.backgroundColor = setting?.iconBackgroundColor.color
        highlightColor?.backgroundColor = setting?.highlightColor.color
        

        
        //images
        logoImage?.image = setting?.icon
        backgroundImage?.image = setting?.backgroundImage
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //paging text
        var text:String?
        let setting = eventSetting?.setting
        
        if (setting? != nil) {
            text = "\(setting!.pagingText.count) Paging Text Items"
        }
        else {
            text = "0 Paging Text Items"
        }
        pageText?.textLabel?.text = text

        pagingItems = setting?.pagingText
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
        eventSetting?.date = dateField!.date
        
        let setting = eventSetting?.setting
        setting?.textColor.convert(textColor!.backgroundColor!)
        setting?.backgroundColor.convert(backgroundColor!.backgroundColor!)
        setting?.iconBackgroundColor.convert(logobackgroundColor!.backgroundColor!)
        setting?.highlightColor.convert(highlightColor!.backgroundColor!)
        setting?.pagingText = pagingItems!
        setting?.icon = logoImage?.image?
        setting?.backgroundImage = backgroundImage?.image?
        
        
        EventHandler.sharedInstance().save(eventSetting!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let colorPicker = segue.destinationViewController as? ColorPickerViewController {
            colorPicker.colorButton = sender as UIButton
        } else if let pageSelect = segue.destinationViewController as? PagingTextSelect {
            pageSelect.activeSetting = eventSetting?.setting
        }
    }
    
    @IBAction func defaultTapped(AnyObject) {
        DefaultEventHandler.sharedInstance().save(eventSetting!.objectId)
    }
}
