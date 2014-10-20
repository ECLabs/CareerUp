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

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        println("hide \(hide)")
        if hide{
            self.dismissViewControllerAnimated(false, completion: {})
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTapped(AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {})
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
