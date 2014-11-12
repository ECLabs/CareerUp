//
//  LoginViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 11/12/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet var loading:UIActivityIndicatorView?
    @IBOutlet var userField:UITextField?
    @IBOutlet var passField:UITextField?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loading?.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }

    @IBAction func attemptLogin(){
        let username = userField!.text
        let password = passField!.text
        
        loading?.startAnimating()
    
        println("Attempting login as \(username)")
        PFUser.logInWithUsernameInBackground(username, password:password) {(user: PFUser!, error: NSError!) -> Void in
          if user != nil {
            println("Login success")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("settings") as UITableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            self.loading?.stopAnimating()
          } else {
            // The login failed. Check error to see why.
            let alert = UIAlertView(title: "Login Failed", message: "Username and password combination not found or no internet connection", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            println(error)
            self.loading?.stopAnimating()
          }
        }
    }
}
