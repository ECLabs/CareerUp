import UIKit

class ApplicantsTableViewController: UITableViewController {
    var selectedIndex = 0
    var loadDelay:NSTimer?
    var loadedContent = -1
    var candidateArray:[Candidate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CandidateHandler.sharedInstance().get()
    }
    
    func reloadTable(timer: NSTimer){
        let loadingCount = CandidateHandler.sharedInstance().loadingCount
        let reloaded = CandidateHandler.sharedInstance().reloaded
        
        if reloaded {
            loadedContent = -1
            CandidateHandler.sharedInstance().reloaded = false
        }
        
        if loadedContent != 0 {
            println("load \(loadingCount)")
            self.tableView.reloadData()
            loadedContent = loadingCount
            loadDelay = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "reloadTable:", userInfo: nil, repeats: false)
        }
        else {
            loadDelay = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "reloadTable:", userInfo: nil, repeats: false)
            CandidateHandler.sharedInstance().count()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        loadDelay?.invalidate()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadDelay = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "reloadTable:", userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        candidateArray = CandidateHandler.sharedInstance().candidates + CandidateHandler.sharedInstance().localCandidates
    
        return candidateArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resumeCell", forIndexPath: indexPath) as UITableViewCell
        let resume = candidateArray[indexPath.row]
        
        cell.textLabel.text = resume.email
        cell.detailTextLabel?.text = "\(resume.firstName) \(resume.lastName)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row as Int
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
       let applicantDetail: ApplicantDetailTableViewController = segue.destinationViewController as ApplicantDetailTableViewController
        
        let selectedResume = candidateArray[selectedIndex]
        applicantDetail.applicantResume = selectedResume
        
        applicantDetail.title = selectedResume.email
    }
}
