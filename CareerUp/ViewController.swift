//
//  ViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 9/30/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
    var map:MKMapView?
    var overlayButton:UIButton?
    var showMap = false
    
    @IBOutlet var pageScroll:UIScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
        
        map = MKMapView(frame: self.view.frame)
        self.view.insertSubview(map!, atIndex: 0)
        
        
        overlayButton = UIButton(frame: self.view.frame)
        self.view.insertSubview(overlayButton!, atIndex: 1)
        overlayButton?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        overlayButton?.addTarget(self, action: "toggleFullscreenMap", forControlEvents: UIControlEvents.TouchUpInside)
        
        updateMapView()
        
        pageScroll?.backgroundColor = UIColor.blueColor()
        
        let firstText = UITextView(frame: pageScroll!.frame)
        firstText.text = "jklafjsdfklasdkl aklsdf jkalsjdfkl asdkf jklsdfj ldjs lkjsdfl jasdlkfj aklsd klsaj dflksjd fkljsdfl ksadklf jlksdfj lksdjf lkjsadf"
        firstText.textAlignment = NSTextAlignment.Center
        firstText.backgroundColor = UIColor.whiteColor()
        
        pageScroll?.contentSize = CGSizeMake(pageScroll!.frame.width*3, pageScroll!.frame.height)
        pageScroll?.addSubview(firstText)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        map?.frame = CGRectMake(0, 0, size.width, size.height)
        overlayButton?.frame = CGRectMake(0, 0, size.width, size.height)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {

        let hideNav = (viewController == self)
        
        navigationController.setNavigationBarHidden(hideNav, animated: true)
        
    }
    
    @IBAction func toggleFullscreenMap(){
        self.navigationController?.setNavigationBarHidden(showMap, animated: true)
        
        UIView.animateWithDuration(1, animations: {
            for object in self.view.subviews {
            
                if object_getClassName(object) == object_getClassName(self.map){
                    continue
                }
                
                let subview = object as UIView

                if self.showMap {
                    subview.alpha = 1
                }
                else {
                    subview.alpha = 0
                }
            }
        })
        showMap = !showMap
        
    }
    

    
    func updateMapView(){
    
        let address = "1934 Old Gallows Road Vienna, VA 22182"
        
        let gecooder = CLGeocoder()

        gecooder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if ((placemarks.count > 0) && error == nil) {
            
                let pm = placemarks[0] as CLPlacemark
                
                
        
                let pin = MKPointAnnotation()
                pin.coordinate = pm.location.coordinate
                
                self.map?.addAnnotation(pin)
                
                
                let region = MKCoordinateRegion(center:  pm.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                
                // calulate gps point on outside of the circle
                // it may be more effective to fly between job locations
                
                self.map?.setRegion(region, animated: true)
            }
        })
    }
}

