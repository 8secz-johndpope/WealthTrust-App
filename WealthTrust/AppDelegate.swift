    //
//  AppDelegate.swift
//  WealthTrust
//
//  Created by Hemen Gohil on 8/30/16.
//  Copyright © 2016 Hemen Gohil. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
    
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
    let objDefault=NSUserDefaults.standardUserDefaults()
    func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.blueColor()
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        if objDefault.valueForKey("passcode") == nil {
        LTHPasscodeViewController.deletePasscode()
        }
        
        
        Fabric.with([Crashlytics.self])

        // Registering for Push Notification...
        LTHPasscodeViewController.useKeychain(false)
        setUpPushNotifications(application)
        
        SharedManager.copyFile(DB_NAME)

        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //Change status bar color
        let statusBar: UIView = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        if statusBar.respondsToSelector("setBackgroundColor:") {
            statusBar.backgroundColor = UIColor.defaultStatusBlue
        }

        if sharedInstance.userDefaults.boolForKey(kIsOpenedFirstTime) {
            // Proceed if Opened Second Time...
            self.createMenuView()
            
        }else{
            // Proceed if opened first Time..
            
            
        }

        let allUser = DBManager.getInstance().getAllUser()
        if allUser.count==0
        {
            sharedInstance.generateToken()

        }else{
            let objUser = allUser.objectAtIndex(0) as! User
            sharedInstance.objLoginUser = objUser
            
            sharedInstance.generateUserToken()

        }


        SharedManager.appDelegate = self
        

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
        print("dfdf")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if (sharedInstance.userDefaults.objectForKey(kToken) != nil) {
            print("Token IS : \(sharedInstance.userDefaults.objectForKey(kToken))")
            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                sharedInstance.SynchUsedInfo()
                
                sharedInstance.SyncAppConf()
                sharedInstance.SyncDynamicText()

                sharedInstance.SyncMFAccount()
            
            
//            })

        }
    }

    func applicationWillTerminate(application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Registering for Push Notification...
    func setUpPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        SharedManager.sharedInstance.deviceToken = tokenString;
        print("Device Token:", SharedManager.sharedInstance.deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //        let aps = userInfo["aps"] as! [String: AnyObject]
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Do something serious in a real app.
        print("Received Local Notification:")
        print(notification.alertBody)
        
        let alert = UIAlertController(title: APP_NAME, message: notification.alertBody, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
        }))
        
        //        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }

    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        
        
        
        
        if (self.window?.rootViewController is ExSlideMenuController) {
            print("YESSSS")
            
            print(self.window?.rootViewController)
            
            let objViewSlide = self.window?.rootViewController as! ExSlideMenuController
            print(objViewSlide)
            print(objViewSlide.navigationController?.viewControllers)

            if UIApplication.topViewController() is SignatureScreen {
                    return UIInterfaceOrientationMask.Landscape;
            }
            
            
//            if self.window?.rootViewController is UINavigationController {
//                let nav = self.window?.rootViewController as! UINavigationController
//                for viewControll in nav.viewControllers {
//                    if viewControll is SignatureScreen {
//                        return UIInterfaceOrientationMask.Landscape;
//                    }
//                }
//            }

            
        }else{
            
        }
        
        
        return UIInterfaceOrientationMask.Portrait;
        
    }

}

