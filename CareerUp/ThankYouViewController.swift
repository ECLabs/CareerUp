//
//  ThankYouViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/20/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
    var hide = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        println("hide \(hide)")
        if hide{
            self.dismissViewControllerAnimated(false, completion: {})
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeTapped(AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {})
    }
}
