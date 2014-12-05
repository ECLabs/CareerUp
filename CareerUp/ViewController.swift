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
    var loadDelay:NSTimer?
    var flyTimer:NSTimer?
    var currentPin = 0
    var loadedContent = -1;
    var pagingView:UIView?
    let gradient : CAGradientLayer = CAGradientLayer()
    
    
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
        
        let cor1 = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3).CGColor // lighter
        let cor2 = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8).CGColor // darker
        let arrayColors = [cor1, cor2]
        
        
        gradient.frame = overlayButton!.bounds
        gradient.colors = arrayColors
        overlayButton!.layer.insertSublayer(gradient, atIndex: 0)
        overlayButton!.addTarget(self,
            action: "toggleFullscreenMap",
            forControlEvents: UIControlEvents.TouchUpInside)
        
        LocationHandler.sharedInstance().get()
        updateMapView()
        
        self.loadDelay = NSTimer.scheduledTimerWithTimeInterval(0.2,
            target: self,
            selector: "updateMapView",
            userInfo: nil,
            repeats: false)

        flyTimer = NSTimer.scheduledTimerWithTimeInterval(4,
            target: self,
            selector: "flyBetweenLocations",
            userInfo: nil,
            repeats: true)
        
        submitButton?.layer.cornerRadius = 33
        submitButton?.clipsToBounds = true
        currentEvent = DefaultEventHandler.sharedInstance().get()
        loadEvent(currentEvent!)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        map?.frame = CGRectMake(0, 0, size.width, size.height)
        gradient.frame = CGRectMake(0, 0, size.width, size.height)
        overlayButton?.frame = CGRectMake(0, 0, size.width, size.height)
    }
    
    func loadEvent(loadEvent:Event){
        currentEvent = loadEvent
        iconBackground?.backgroundColor = loadEvent.setting.iconBackgroundColor.color
        settingButton?.tintColor = loadEvent.setting.highlightColor.color
        submitButton?.tintColor = loadEvent.setting.highlightColor.color
        //overlayButton?.backgroundColor = loadEvent.setting.backgroundColor.color
        //icon?.image = loadEvent.setting.icon
        
        pageIndicator?.numberOfPages = loadEvent.setting.pagingText.count
        pageTimer?.invalidate()
        if loadEvent.setting.pagingText.count > 0 {
            pagingView = buildPagingView(120.0 as CGFloat,
                overallWidth: self.view.frame.width - 200.0,
                title:getPageTextTitle(loadEvent.setting.pagingText[0]),
                body:getPageTextBody(loadEvent.setting.pagingText[0]))
            
            self.view.addSubview(pagingView!)
            
            pageTimer = NSTimer.scheduledTimerWithTimeInterval(8,
                target: self,
                selector: "pageInfo",
                userInfo: nil,
                repeats: true)
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
            let width = self.pagingView!.frame.width
            let height:CGFloat = self.pagingView!.frame.height
            let x = (self.view.frame.width - width)/2
            let y = pageIndicator!.frame.origin.y - height - 30
            self.pagingView?.frame = CGRectMake(x, y, width, height)
        }
    }
    
    func getPageTextString(page:PageText)->String{
        return "\(page.title)\n\n\(page.content)"
    }
    
    func getPageTextTitle(page:PageText)->String{
        return "\(page.title)"
    }
    func getPageTextBody(page:PageText)->String{
        return "\(page.content)"
    }
    
    func pageInfo() { 
        let frameWidth = self.view.frame.width - 200.0
        let height:CGFloat = 120.0
        let y = pageIndicator!.frame.origin.y - height - 30
        let x = (self.view.frame.width - frameWidth)/2
        
        let current = self.pageIndicator!.currentPage
        
        if current < self.pageIndicator!.numberOfPages - 1{
            self.pageIndicator!.currentPage = current + 1
        } else {
            self.pageIndicator!.currentPage = 0
        }
        
        let newPagingView = buildPagingView(120.0 as CGFloat,
            overallWidth: self.view.frame.width - 200.0,
            title:getPageTextTitle(self.currentEvent!.setting.pagingText[self.pageIndicator!.currentPage]),
            body:getPageTextBody(self.currentEvent!.setting.pagingText[self.pageIndicator!.currentPage]))

        newPagingView.frame = CGRectMake(x, y, newPagingView.frame.width, newPagingView.frame.height)

        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "pageInfo")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        newPagingView.addGestureRecognizer(swipeLeft)
        
        let width = self.view.frame.width
        
        newPagingView.center = CGPointMake(newPagingView.center.x + width, newPagingView.center.y)
        self.view.addSubview(newPagingView)
        
        UIView.animateWithDuration(0.25, animations: {
            self.animating = true
            
            newPagingView.center = CGPointMake(newPagingView.center.x - width, newPagingView.center.y)
            newPagingView.alpha = self.overlayButton!.alpha
            
            let x = newPagingView.center.x - width
            let y = newPagingView.center.y
            
            self.pagingView!.center = CGPointMake(x,y)
            self.pagingView!.alpha = 0;

            self.pageIndicator!.updateCurrentPageDisplay()
        }, completion: { finished in
            self.animating = false
            self.pagingView!.removeFromSuperview()
            self.pagingView = newPagingView
        })
        
    }

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if !showMap {
            if let hideNav = viewController as? ViewController {
                navigationController.setNavigationBarHidden(true, animated: true)
            }
            else {
                navigationController.setNavigationBarHidden(false, animated: true)
            }
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
            
            // active current pin
            map?.selectAnnotation(pin, animated: true)
            
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
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func toggleFullscreenMap(){
        self.navigationController?.setNavigationBarHidden(showMap, animated: true)
        
        UIView.animateWithDuration(0.25, animations: {
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
            flyTimer = NSTimer.scheduledTimerWithTimeInterval(4,
                target: self,
                selector: "flyBetweenLocations",
                userInfo: nil,
                repeats: true)
        }
        else{
            flyTimer?.invalidate()
        }
        
        showMap = !showMap
    }
    
    func buildPagingView(overallHeight:CGFloat, overallWidth:CGFloat, title:NSString, body:NSString) -> UIView {
        var paging = UIView(frame: CGRectMake(0,0,overallWidth, overallHeight))
        let titleHeight = 35.0 as CGFloat
        let bodyHeight = overallHeight - titleHeight
        let y = pageIndicator!.frame.origin.y - overallHeight - 30
        let x = (self.view.frame.width - overallWidth)/2

        var pagingTextTitle = UITextView()
        pagingTextTitle.frame = CGRectMake(0, 0, overallWidth, titleHeight)
        pagingTextTitle.font = UIFont.boldSystemFontOfSize(22)
        pagingTextTitle.textColor = currentEvent!.setting.textColor.color
        pagingTextTitle.textAlignment = NSTextAlignment.Center
        pagingTextTitle.backgroundColor = UIColor.clearColor()
        pagingTextTitle.text = title
        paging.addSubview(pagingTextTitle)
        
        var pagingTextBody = UITextView()
        pagingTextBody.frame = CGRectMake(0, titleHeight, overallWidth, bodyHeight)
        pagingTextBody.font = UIFont.systemFontOfSize(17)
        pagingTextBody.textColor = currentEvent!.setting.textColor.color
        pagingTextBody.textAlignment = NSTextAlignment.Center
        pagingTextBody.backgroundColor = UIColor.clearColor()
        pagingTextBody.text = body
        paging.addSubview(pagingTextBody)
        return paging
    }
}
