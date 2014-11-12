import UIKit

class FormTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate
{
    @IBOutlet var firstName:UITextField?
    @IBOutlet var lastName:UITextField?
    @IBOutlet var email:UITextField?
    @IBOutlet var jobTitle:UITextField?
    @IBOutlet var linkedIn:UITextField?
    @IBOutlet var comments:UITextView?
    @IBOutlet var resumeScroll:UIScrollView?
    @IBOutlet var emailCell:UITableViewCell?
    
    var client:LIALinkedInHttpClient?
    
    var imageViews:[UIImageView] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginToLinkedIn()
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
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        var currentViewCount:CGFloat = CGFloat(imageViews.count)
        
        println(resumeScroll!.subviews)
        
        let width:CGFloat = resumeScroll!.frame.size.width
        let offset:CGFloat = width / 2.0 * currentViewCount + (8 * currentViewCount)

        
        imageView.frame = CGRectMake(offset, 0, width/2, resumeScroll!.frame.size.height)
        
        resumeScroll?.addSubview(imageView)
        
        imageViews.append(imageView)
        currentViewCount++
        resumeScroll?.contentSize = CGSizeMake(resumeScroll!.frame.width/2 * currentViewCount + (8 * currentViewCount), resumeScroll!.frame.size.height)
        
        
        picker.dismissViewControllerAnimated(true, completion: {})
    }
    
    func validateEmail(email:String)->Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

        let range = NSMakeRange(0, countElements(email))

        let regex = NSRegularExpression(pattern: emailRegex, options: nil, error: nil)
        
        let matches = regex!.matchesInString(email, options: NSMatchingOptions.ReportProgress, range: range)
        return (matches.count > 0)
    }
    
    @IBAction func emailChanged() {
        if(validateEmail(email!.text)){
            emailCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            emailCell?.accessoryType = UITableViewCellAccessoryType.None
        }
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
            let submission = Candidate()
            submission.firstName = firstName!.text
            submission.lastName = lastName!.text
            submission.email = email!.text
            submission.linkedIn = linkedIn!.text
            submission.comments = comments!.text
            submission.jobTitle = jobTitle!.text
            
            for imageView in imageViews {
                submission.resumeImages.append(imageView.image!)
            }

            CandidateHandler.sharedInstance().candidates.append(submission)
            CandidateHandler.sharedInstance().save(submission)
            self.navigationController?.popViewControllerAnimated(false)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("thankyou") as ThankYouViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    @IBAction func cameraTapped(AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
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
    
    @IBAction func loginToLinkedIn() {
        if client == nil {
            initilizeClient()
        }
        
        client?.getAuthorizationCode({(code:String!) in
            self.getAccessToken(code)
        }, cancel: {
            println("cancelled")
        }, failure: {(error) in
            println(error)
        })
    }
    
    func getAccessToken(code:String){
        self.client?.getAccessToken(code, success: {(accessTokenData) in
            let converted = accessTokenData as NSDictionary
            let token = converted.objectForKey("access_token") as String
            self.getProfile(token)
        }, failure: {(error) in
            println(error)
        })
    }
    
    func initilizeClient() {
        let application = LIALinkedInApplication(redirectURL: "http://sizzletec.com",
        clientId: "77fioioshfj7u8",
        clientSecret: "VbQKJkpJf0Z7p6kM",
        state: "DCEEFWF45453sdffef424",
        grantedAccess: ["r_basicprofile", "r_emailaddress"])
        
        self.client = LIALinkedInHttpClient(forApplication: application, presentingViewController: self)
    }
    
    func getProfile(token:String) {
        println(token)
        client?.GET("https://api.linkedin.com/v1/people/~:(first-name,last-name,email-address,public-profile-url)?oauth2_access_token=\(token)&format=json", parameters: nil,
        success: { (operation, result) in
            println(result)
            let resultDic = result as NSDictionary
            
            
            if let firstNameResult = resultDic.objectForKey("firstName") as? String {
                self.firstName?.text = firstNameResult
            }
            
            if let lastNameResult = resultDic.objectForKey("lastName") as? String {
                self.lastName?.text = lastNameResult
            }
            
            if let emailResult = resultDic.objectForKey("emailAddress") as? String {
                self.email?.text = emailResult
            }
            
            if let urlResult = resultDic.objectForKey("publicProfileUrl") as? String {
                self.linkedIn?.text = urlResult
            }
  
        }, failure: { (operation, result) in
            println(result)
        })
    }
}

