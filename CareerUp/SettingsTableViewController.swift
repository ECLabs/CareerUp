//
//  SettingsTableViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/6/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {
    @IBOutlet var textColor:UIButton?
    @IBOutlet var backgroundColor:UIButton?
    @IBOutlet var highlightColor:UIButton?
    @IBOutlet var pageText:UITextView?
    @IBOutlet var logoImage:UIImageView?
    @IBOutlet var backgroundImage:UIImageView?
    var selectedPicker:String?

    override func viewDidLoad() {
        super.viewDidLoad()
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

}
