import UIKit

class PagingTextSelect: UITableViewController {
    var activeSetting:Setting?
    var selectedIndex = 0


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeSetting!.pagingText.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        let page = activeSetting?.pagingText[indexPath.row]
        cell.textLabel.text = page?.title
        cell.detailTextLabel?.text = page?.content

        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let pageDetails = segue.destinationViewController as? PagingTextDetails {
            pageDetails.title = "Page"
            pageDetails.activeSetting = activeSetting
            pageDetails.pageIndex = selectedIndex
        }
    }
    
    @IBAction func AddPage(AnyObject) {
        let page = PageText()
        activeSetting?.pagingText.append(page)
        self.tableView.reloadData()
    }
}
