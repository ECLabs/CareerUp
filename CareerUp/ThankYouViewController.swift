import UIKit

class ThankYouViewController: UIViewController {
    var hide = false

    override func viewWillAppear(animated: Bool) {
        if hide{
            self.dismissViewControllerAnimated(false, completion: {})
        }
    }
    
    @IBAction func closeTapped(AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {})
    }
}
