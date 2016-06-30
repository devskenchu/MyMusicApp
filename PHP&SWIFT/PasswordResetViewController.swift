//
//  PasswordResetViewController.swift
//  PHP&SWIFT
//
//  Created by puneeth on 29/06/16.
//  Copyright © 2016 puneeth. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    @IBOutlet var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        let emailAddress = self.emailTextField.text
        
        
        if (emailAddress!.isEmpty) {
            ReusableFunctions.displayAlertMessage("Please Enter Valid Email", viewController: self)
            return
        }
        
        emailTextField.resignFirstResponder()
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.label.text = "Loading"
        spinningActivity.detailsLabel.text = "Please wait..."
        
        let myUrl = NSURL(string: "http://localhost/SwiftPHP/scripts/requestNewPassword.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "userEmail=\(emailAddress!)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                
                if let parsedJson: NSDictionary = json {
                    print(parsedJson)
                    
                    let userId = parsedJson["userEmail"] as? String
                    if (userId != nil) {
                   
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            spinningActivity.hideAnimated(true)
                            ReusableFunctions.displayAlertMessage(parsedJson["message"] as! String, viewController: self)
                        }
                    }else {
                        let alert = UIAlertController(title: "Error", message: parsedJson["message"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            spinningActivity.hideAnimated(true)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
            } catch let error as JSONError {
                
                let alert = UIAlertController(title: "Registration Error", message: error.rawValue, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    spinningActivity.hideAnimated(true)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                //print(error.rawValue)
            } catch let error as NSError {
                let alert = UIAlertController(title: "Registration Error", message: error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    spinningActivity.hideAnimated(true)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                // print(error.debugDescription)
            }
            }.resume()
        
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

