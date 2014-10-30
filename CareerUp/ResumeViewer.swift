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
    }
}
