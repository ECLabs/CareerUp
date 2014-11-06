import UIKit

class ResumeViewer: UIViewController {
    @IBOutlet var webView:UIWebView!
    var imageData:NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadData(imageData, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: nil)
    }
}
