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
    var animating = false
    
    @IBOutlet var icon:UIImageView?
    @IBOutlet var settingButton:UIButton?
    @IBOutlet var submitButton:UIButton?
    var pagingText:UITextView?
    @IBOutlet var pageIndicator:UIPageControl?
    
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
        
        let loadDelay = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "pageInfo", userInfo: nil, repeats: true)
        
        pagingText = UITextView()
        pagingText?.text = "Growth\n\nStay on top of your game with company sponsored training, and the opportunity to support cutting-edge internal R&D programs."
        pagingText?.font = UIFont.boldSystemFontOfSize(14)
        pagingText?.textColor = UIColor.whiteColor()
        pagingText?.textAlignment = NSTextAlignment.Center
        pagingText?.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(pagingText!)
    }
    
    override func viewDidLayoutSubviews() {
        if !animating {
            let width = self.view.frame.width - 80.0
            let height:CGFloat = 84.0
            
            let y = pageIndicator!.frame.origin.y - height
            self.pagingText?.frame = CGRectMake(40, y, width, height)
        }
    }
    
    func pageInfo(){

        let frameWidth = self.view.frame.width - 80.0
        let height:CGFloat = 84.0
        let y = pageIndicator!.frame.origin.y - height
        
        let newTextView = UITextView(frame: CGRectMake(40, y, frameWidth, height))
        newTextView.font = self.pagingText?.font
        newTextView.text = "\(pageIndicator!.currentPage + 1)"
        newTextView.textColor = self.pagingText?.textColor
        newTextView.textAlignment = self.pagingText!.textAlignment
        newTextView.backgroundColor = UIColor.clearColor()
        
        
        
        let width = self.view.frame.width
        
        newTextView.center = CGPointMake(newTextView.center.x + width, newTextView.center.y)
        self.view.addSubview(newTextView)
        
        UIView.animateWithDuration(3, animations: {
            self.animating = true
            
            newTextView.center = CGPointMake(newTextView.center.x - width, newTextView.center.y)

            let x = newTextView.center.x - width
            let y = newTextView.center.y
            
            self.pagingText!.center = CGPointMake(x,y)
            
                        
            let current = self.pageIndicator!.currentPage
            
            if current < self.pageIndicator!.numberOfPages - 1{
                self.pageIndicator!.currentPage = current + 1
            } else {
                self.pageIndicator!.currentPage = 0
            }
            
            self.pageIndicator!.updateCurrentPageDisplay()
        }, completion: { finished in
            self.animating = false
            self.pagingText!.removeFromSuperview()
            self.pagingText! = newTextView
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        icon?.backgroundColor = UIColor.lightGrayColor()
//        settingButton?.tintColor = UIColor.orangeColor()
//        submitButton?.tintColor = UIColor.orangeColor()
//        overlayButton?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)

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
        if !showMap {
            let hideNav = (viewController == self)
        
            navigationController.setNavigationBarHidden(hideNav, animated: true)
        }
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

