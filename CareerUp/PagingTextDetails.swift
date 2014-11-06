import UIKit

class PagingTextDetails: UITableViewController {
    @IBOutlet var titleField:UITextField?
    @IBOutlet var contentField:UITextView?
    
    var pageIndex = 0
    var activeSetting:Setting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page = activeSetting?.pagingText[pageIndex]
        titleField?.text = page?.title
        contentField?.text = page?.content
    }

    @IBAction func ApplyPage(AnyObject) {
        let page = activeSetting?.pagingText[pageIndex]
        page?.title = titleField!.text
        page?.content = contentField!.text
        page?.updatedAt = NSDate()
        self.navigationController?.popViewControllerAnimated(true)
    }
}
