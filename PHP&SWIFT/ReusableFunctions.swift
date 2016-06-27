//
//  ReusableFunctions.swift
//  PHP&SWIFT
//
//  Created by puneeth on 23/06/16.
//  Copyright © 2016 puneeth. All rights reserved.
//

import Foundation
import UIKit

class ReusableFunctions: NSObject{
    class func displayAlertMessage(userMessage:String, viewController:UIViewController){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okButton)
        viewController.presentViewController(myAlert, animated: true, completion: nil)
    }
}
