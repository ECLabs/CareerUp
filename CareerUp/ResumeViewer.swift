//
//  ResumeViewer.swift
//  CareerUp
//
//  Created by Adam Emery on 10/29/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class ResumeViewer: UIViewController {
    @IBOutlet var webView:UIWebView!
    var imageData:NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadData(imageData, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
