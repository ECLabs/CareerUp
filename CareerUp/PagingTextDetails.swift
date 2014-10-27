//
//  PagingTextDetails.swift
//  CareerUp
//
//  Created by Adam Emery on 10/27/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class PagingTextDetails: UITableViewController {
    var pageIndex = 0
    var activeSetting:Setting?
    
    @IBOutlet var titleField:UITextField?
    @IBOutlet var contentField:UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page = activeSetting?.pagingText[pageIndex]
        titleField?.text = page?.title
        contentField?.text = page?.content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func ApplyPage(AnyObject) {
        let page = activeSetting?.pagingText[pageIndex]
        page?.title = titleField!.text
        page?.content = contentField!.text
        page?.modified = true
        page?.updatedAt = NSDate()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func DeletePage(AnyObject) {
        //delete from parse
        activeSetting?.pagingText.removeAtIndex(pageIndex)
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
