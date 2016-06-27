//
//  SignUpViewController.swift
//  PHP&SWIFT
//
//  Created by puneeth on 16/05/16.
//  Copyright © 2016 puneeth. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func SignUpButtonPressed(sender: AnyObject) {
        
        let userEmail = self.emailTextField.text
        let userPassword = self.passwordTextField.text
        let userConfirmPasswordTextField = self.confirmPasswordTextField.text
        let userfirstName = self.firstNameTextField.text
        let userlastName = self.lastNameTextField.text
        
        if(userEmail!.isEmpty || userPassword!.isEmpty || userConfirmPasswordTextField!.isEmpty || userfirstName!.isEmpty || userlastName!.isEmpty) {            
            ReusableFunctions.displayAlertMessage("All fields are mandatory", viewController: self)
            return
        }
        
        if(userPassword != userConfirmPasswordTextField) {
            ReusableFunctions.displayAlertMessage("Password Do not Match", viewController: self)
            return
        }
        
        //Send HTTP POST
        let url = NSURL(string: "http://localhost/SwiftPHP/scripts/registerUser.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let postBody = "userEmail=\(userEmail!)&userPassword=\(userPassword!)&userFirstName=\(userfirstName!)&userLastName=\(userlastName!)"
        request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                
                if let parsedJson: NSDictionary = json {
                    let userId = parsedJson["userId"] as? String
                    if (userId != nil) {
                        let alert = UIAlertController(title: "Registration Successful", message: parsedJson["message"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }else {
                        let alert = UIAlertController(title: "Registration Error", message: parsedJson["message"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
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
