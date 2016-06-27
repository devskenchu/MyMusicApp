//
//  LoginViewController.swift
//  PHP&SWIFT
//
//  Created by puneeth on 16/05/16.
//  Copyright © 2016 puneeth. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if(email!.isEmpty || password!.isEmpty){
            ReusableFunctions.displayAlertMessage("Enter all Fields", viewController: self)
            return
        }
        
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.label.text = "Loading"
        spiningActivity.detailsLabel.text = "Please wait"
        
        
        let url = NSURL(string: "http://localhost/SwiftPHP/scripts/UserSignIn.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let postBody = "userEmail=\(email!)&userPassword=\(password!)"
        
        request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            (data,response,error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                
                if let parsedJson: NSDictionary = json {
                    if parsedJson["userId"] != nil{
                        NSUserDefaults.standardUserDefaults().setObject(parsedJson["userFirstName"], forKey: "userFirstName")
                        NSUserDefaults.standardUserDefaults().setObject(parsedJson["userLastName"], forKey: "userLastName")
                           NSUserDefaults.standardUserDefaults().setObject(parsedJson["userId"], forKey: "userId")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
//                        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
//                        
//                        let mainPageNav = UINavigationController(rootViewController: mainPage)
//                        NSOperationQueue.mainQueue().addOperationWithBlock({
//                            spiningActivity.hideAnimated(true)
//                            let appDelegate = UIApplication.sharedApplication().delegate
//                            appDelegate?.window??.rootViewController = mainPageNav
                    //})
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                        spiningActivity.hideAnimated(true)
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.buildNavigationDrawer()
                    })
                    }else {
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            spiningActivity.hideAnimated(true)
                            ReusableFunctions.displayAlertMessage(parsedJson["message"] as! String, viewController: self)
                        })
                    }
                }
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
}

