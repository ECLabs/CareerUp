import UIKit

class SettingSelectTableViewController: UITableViewController {
    var selectedIndex = 0
    var loadDelay:NSTimer?
    var loadedContent = -1;
    var eventArray:[Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventHandler.sharedInstance().get()
    }
    
    func reloadTable(timer: NSTimer){
        let loadingCount = EventHandler.sharedInstance().loadingCount
        let reloaded = EventHandler.sharedInstance().reloaded
        
        if reloaded {
            loadedContent = -1
            EventHandler.sharedInstance().reloaded = false
        }
        
        if loadedContent != 0 {
            println("load \(loadingCount)")
            self.tableView.reloadData()
            loadedContent = loadingCount
            loadDelay = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "reloadTable:", userInfo: nil, repeats: false)
        }
        else {
            loadDelay = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "reloadTable:", userInfo: nil, repeats: false)
            EventHandler.sharedInstance().count()
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
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventArray = EventHandler.sharedInstance().events + EventHandler.sharedInstance().localEvents
        return eventArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let setting = eventArray[indexPath.row]
        
        cell.textLabel?.text = setting.name
        cell.detailTextLabel?.text = setting.details
        return cell

    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row as Int
        return indexPath
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
        let settingDetail: SettingsTableViewController = segue.destinationViewController as SettingsTableViewController
        let selectedEvent = eventArray[selectedIndex]
        settingDetail.eventSetting = selectedEvent
    }
    
    @IBAction func AddSettings(AnyObject) {
        let event = Event()
        event.name = "New Event"
        EventHandler.sharedInstance().save(event)
        self.tableView.reloadData()
    }
}
