//
//  MainPageViewController.swift
//  PHP&SWIFT
//
//  Created by puneeth on 23/06/16.
//  Copyright © 2016 puneeth. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userDetail: UILabel!
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 4
        self.userImage.clipsToBounds = true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let userFirstName = NSUserDefaults.standardUserDefaults().stringForKey("userFirstName")
        let userLastName = NSUserDefaults.standardUserDefaults().stringForKey("userLastName")
        
        let userFullName = userFirstName! + " " + userLastName!
        userDetail.text = userFullName
        
        if(userImage.image == nil) {
            let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
            
            let fileName = userId! + ".jpg"
            
            let imageUrlPath = NSURL(string: "http://localhost/SwiftPHP/Profile_Pic/\(userId!)/\(fileName)")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let imageData = NSData(contentsOfURL: imageUrlPath!)
                if imageData != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.userImage.image = UIImage(data: imageData!)
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectProfilePhotoButtonPressed(sender: AnyObject) {
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myImagePicker, animated: true,completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        userImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true,completion: nil)
        
        UploadRequest()
        
    }
    
    func UploadRequest()
    {
        let url = NSURL(string: "http://localhost/SwiftPHP/scripts/ImageUpload.php")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        //define the multipart request type
        
        let userId:String? = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        let param = [
            "userId" : userId!
        ]
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (userImage.image == nil)
        {
            return
        }
        
        let image_data = UIImagePNGRepresentation(userImage.image!) //
        
        if(image_data == nil)
        {
            return
        }
        
        let body = NSMutableData()
        
        let fname = userId! + ".jpg"
        let mimetype = "image/jpg"
        
        //define the data post parameter
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        for (key, value) in param {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(image_data!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
         
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            dispatch_async(dispatch_get_main_queue(), {

                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
            });
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
            ReusableFunctions.displayAlertMessage("Profile Image Failed to Upload. Try Again!", viewController: self)
            return
            }

            ReusableFunctions.displayAlertMessage("Profile Image Uploaded Successfully!", viewController: self)
        }
        task.resume()
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    @IBAction func SignOutButtonPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let signInViewPresent = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
        
        let signInNav = UINavigationController(rootViewController: signInViewPresent)
        
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = signInNav
    }
    
    @IBAction func leftSideMenuTapped(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerController?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
    
}
