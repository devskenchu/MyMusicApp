//
//  AboutViewController.swift
//  PHP&SWIFT
//
//  Created by puneeth on 27/06/16.
//  Copyright © 2016 puneeth. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func leftMenuTapped(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerController?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
}
