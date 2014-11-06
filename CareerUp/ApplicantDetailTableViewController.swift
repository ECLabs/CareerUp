import UIKit

class ApplicantDetailTableViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet var firstName:UITextField?
    @IBOutlet var lastName:UITextField?
    @IBOutlet var email:UITextField?
    @IBOutlet var jobTitle:UITextField?
    @IBOutlet var linkedIn:UITextField?
    @IBOutlet var comments:UITextView?
    @IBOutlet var resume:UITableViewCell?
    @IBOutlet var notes:UITextView?
    
    var applicantResume:Candidate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName?.text = applicantResume?.firstName
        lastName?.text = applicantResume?.lastName
        email?.text = applicantResume?.email
        jobTitle?.text = applicantResume?.jobTitle
        linkedIn?.text = applicantResume?.linkedIn
        comments?.text = applicantResume?.comments
        
        if applicantResume?.pdfData == nil {
            resume?.textLabel?.text = "No Attached Resume"
            resume?.userInteractionEnabled = false
            resume?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        notes?.text = applicantResume?.notes
        notes?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        applicantResume?.editing = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        applicantResume?.editing = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let resumeView: ResumeViewer = segue.destinationViewController as ResumeViewer
        resumeView.imageData = applicantResume?.pdfData
    }

    func textViewDidEndEditing(textView: UITextView) {
        applicantResume?.notes = textView.text
        CandidateHandler.sharedInstance().save(applicantResume!)
    }
}
