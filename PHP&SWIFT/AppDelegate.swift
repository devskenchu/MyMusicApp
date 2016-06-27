//
//  AppDelegate.swift
//  PHP&SWIFT
//
//  Created by puneeth on 16/05/16.
//  Copyright © 2016 puneeth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController : MMDrawerController? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        if userId != nil{
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainPage = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController")
//            let mainPageNav = UINavigationController(rootViewController: mainPage)
//            self.window?.rootViewController = mainPageNav
            
                buildNavigationDrawer()
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func buildNavigationDrawer(){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainPage: MainPageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
        
         let leftSide: LeftSideViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController
        
       //  let rightSide: RightSideViewController = mainStoryboard.instantiateViewControllerWithIdentifier("RightSideViewController") as! RightSideViewController
        
        let mainPageNav = UINavigationController(rootViewController: mainPage)
        let leftPageNav = UINavigationController(rootViewController: leftSide)
        //let rightPageNav = UINavigationController(rootViewController: rightSide)
        
        drawerController = MMDrawerController(centerViewController: mainPageNav, leftDrawerViewController: leftPageNav, rightDrawerViewController: nil)
        
        drawerController!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        drawerController!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        
        window?.rootViewController = drawerController

    }


}

