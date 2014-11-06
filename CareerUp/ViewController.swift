import UIKit
import MapKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, MKMapViewDelegate {
    var map:MKMapView?
    var overlayButton:UIButton?
    var showMap = false
    var animating = false
    var currentEvent:Event?
    var pageTimer:NSTimer?
    var pagingText:UITextView?
    var loadDelay:NSTimer?
    var flyTimer:NSTimer?
    var currentPin = 0
    var loadedContent = -1;
    
    @IBOutlet var icon:UIImageView?
    @IBOutlet var iconBackground:UIView?
    @IBOutlet var settingButton:UIButton?
    @IBOutlet var submitButton:UIButton?
    @IBOutlet var pageIndicator:UIPageControl?
    @IBOutlet var gifView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
        
        overlayButton = UIButton(frame: self.view.frame)
        self.view.insertSubview(overlayButton!, atIndex: 1)
        overlayButton?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        overlayButton?.addTarget(self, action: "toggleFullscreenMap", forControlEvents: UIControlEvents.TouchUpInside)
        
        LocationHandler.sharedInstance().get()
        updateMapView()
        
        self.loadDelay = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateMapView", userInfo: nil, repeats: false)

        flyTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "flyBetweenLocations", userInfo: nil, repeats: true)
        
        pagingText = UITextView()
        pagingText?.font = UIFont.boldSystemFontOfSize(14)
        pagingText?.textColor = UIColor.whiteColor()
        pagingText?.textAlignment = NSTextAlignment.Center
        pagingText?.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(pagingText!)
        
        currentEvent = DefaultEventHandler.sharedInstance().get()
        
        loadEvent(currentEvent!)
    }
    
    func loadEvent(loadEvent:Event){
        currentEvent = loadEvent
        iconBackground?.backgroundColor = loadEvent.setting.iconBackgroundColor.color
        settingButton?.tintColor = loadEvent.setting.highlightColor.color
        submitButton?.tintColor = loadEvent.setting.highlightColor.color
        overlayButton?.backgroundColor = loadEvent.setting.backgroundColor.color
        pagingText?.textColor = loadEvent.setting.textColor.color
        
        icon?.image = loadEvent.setting.icon
        
        pageIndicator?.numberOfPages = loadEvent.setting.pagingText.count
        pageTimer?.invalidate()
        if loadEvent.setting.pagingText.count > 0 {
            pagingText?.text = getPageTextString(loadEvent.setting.pagingText[0])
            
            pageTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "pageInfo", userInfo: nil, repeats: true)
        }
        
        if let backgroundImage = loadEvent.setting.backgroundImage {
            gifView?.image = backgroundImage
        }
        
        if loadEvent.setting.hasMap && map == nil {
            map = MKMapView(frame: self.view.frame)
            map?.delegate = self
            self.view.insertSubview(map!, atIndex: 0)
            
        } else {
            map?.removeFromSuperview()
            map = nil
            self.overlayButton?.userInteractionEnabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !animating {
            let width = self.view.frame.width - 80.0
            let height:CGFloat = 84.0
            
            let y = pageIndicator!.frame.origin.y - height
            self.pagingText?.frame = CGRectMake(40, y, width, height)
        }
    }
    
    func getPageTextString(page:PageText)->String{
        return "\(page.title)\n\n\(page.content)"
    }
    
    func pageInfo() { 
        let frameWidth = self.view.frame.width - 80.0
        let height:CGFloat = 84.0
        let y = pageIndicator!.frame.origin.y - height
        
        let newTextView = UITextView(frame: CGRectMake(40, y, frameWidth, height))
        newTextView.font = self.pagingText?.font
        
        newTextView.textColor = self.pagingText?.textColor
        newTextView.textAlignment = self.pagingText!.textAlignment
        newTextView.backgroundColor = UIColor.clearColor()
        newTextView.alpha = self.pagingText!.alpha
        
        
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
            newTextView.text = self.getPageTextString(self.currentEvent!.setting.pagingText[self.pageIndicator!.currentPage])
            
            self.pageIndicator!.updateCurrentPageDisplay()
        }, completion: { finished in
            self.animating = false
            self.pagingText!.removeFromSuperview()
            self.pagingText! = newTextView
        })
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        map?.frame = CGRectMake(0, 0, size.width, size.height)
        overlayButton?.frame = CGRectMake(0, 0, size.width, size.height)
    }

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if !showMap {
            let hideNav = (viewController == self)
        
            navigationController.setNavigationBarHidden(hideNav, animated: true)
        }
    }
    
    func updateMapView(){
        let loadingCount = LocationHandler.sharedInstance().loadingCount
        
        if loadedContent != 0 {
            loadedContent = loadingCount
            dropPins()
            loadDelay = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateMapView", userInfo: nil, repeats: false)
            
        }
    }
    
    func dropPins(){
        map?.removeAnnotations(map?.annotations)
        let locations = LocationHandler.sharedInstance().locations
        
        for location in locations {
            let address = location.address
            let gecooder = CLGeocoder()

            if location.coordinate == nil {
                gecooder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                    if (error == nil && (placemarks.count > 0)) {
                    
                        let pm = placemarks[0] as CLPlacemark
                        location.coordinate = pm.location.coordinate
                        
                        self.dropPinAt(location)
                    }
                })
            }
            else {
                dropPinAt(location)
            }
        }
    }
    
    func dropPinAt(location:Location) {
        let pin = LocationPointAnnotation()
        pin.title = "\(location.name) - \(location.city), \(location.state)"
        let jobNumber = location.jobs.count
        pin.subtitle = "\(jobNumber) Jobs Availible"
        pin.coordinate = location.coordinate!
        pin.location = location
        
        self.map?.addAnnotation(pin)

        let pinview = self.map?.viewForAnnotation(pin)
        self.flyBetweenLocations()
    }
    
    func flyBetweenLocations(){
        let annotations = map?.annotations
        
        if annotations?.count > 0 {
            let pin = annotations?[currentPin] as MKPointAnnotation
            
            let region = MKCoordinateRegion(center:  pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            self.map?.setRegion(region, animated: true)
            
            currentPin++
            if currentPin + 1 > annotations?.count {
                currentPin = 0
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
        let locationAnnotation:LocationPointAnnotation = annotation as LocationPointAnnotation
        
        let identifier = "pinview"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if (pinView == nil) {
            pinView = LocationPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            pinView.annotation = annotation
        }
        let locationView:LocationPinAnnotationView = pinView as LocationPinAnnotationView
        locationView.location = locationAnnotation.location
        
        
        pinView.canShowCallout = true
        pinView.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
    
        let locationView:LocationPinAnnotationView = view as LocationPinAnnotationView
        let location = locationView.location
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("joblist") as JobListingTable
        vc.locations = [location!]
        
        self.navigationController?.showViewController(vc, sender: self)
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
        
        if showMap{
            flyBetweenLocations()
            flyTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "flyBetweenLocations", userInfo: nil, repeats: true)
        }
        else{
            flyTimer?.invalidate()
        }
        
        showMap = !showMap
    }
}

