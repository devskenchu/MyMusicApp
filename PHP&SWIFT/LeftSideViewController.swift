//
//  LeftSideViewController.swift
//  PHP&SWIFT
//
//  Created by puneeth on 27/06/16.
//  Copyright © 2016 puneeth. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var menuItem: [String] = ["Main","About","Sign Out"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        myCell.textLabel?.text = menuItem[indexPath.row]
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as!MainPageViewController
            
            let mainNavPage = UINavigationController(rootViewController:mainPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.drawerController!.centerViewController = mainNavPage
            appDelegate.drawerController?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
            
        case 1:
            
            let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as!AboutViewController
            
            let mainNavPage = UINavigationController(rootViewController:mainPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.drawerController!.centerViewController = mainNavPage
            appDelegate.drawerController?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
            
        case 2:
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let signInViewPresent = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            
            let signInNav = UINavigationController(rootViewController: signInViewPresent)
            
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate?.window??.rootViewController = signInNav
           
            break
        default:
            break
        }
        
    }
    
    

}
