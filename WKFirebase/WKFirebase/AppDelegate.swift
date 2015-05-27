//
//  AppDelegate.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/1/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //MARK: - some statics for passing around data
    static var userId : String?
    static var userName : String?
    static var selectedObjectId : String?
    static var selectedObjectName: String?
    static var wasAssignmentSelected : Bool = false
    
    //MARK: - computed properties
    class var get : AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    class var loginController : UIViewController {
        return get.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier(
            "LoginController") as! UIViewController
    }
    
    class var tabBarController : UIViewController {
        return get.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier(
            "TabBarController") as! UIViewController
    }
    

    //MARK: - app delegate overrides

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //ask user permission to see notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge, categories: nil))
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        //nested nil checks
        if let options = launchOptions,
            value = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                self.application(application, didReceiveLocalNotification: value)
        }
        
        if isUserLoggedIn() {
            println("\(AppDelegate.userName!):\(AppDelegate.userId!) is logged in")
            self.window?.rootViewController = AppDelegate.tabBarController
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
    
    //MARK: - notification and background fetch
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if self.doBackgroundFetch() {
            scheduleLocalNotification()
            completionHandler(.NewData)
        }
        else {
            completionHandler(.NoData)
        }
    }
    
    //this is fired if user clicks on banner
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        switch application.applicationState {
        case .Active: println("Application was active when event received")
        case .Background: println("Application was background when event received")
        case .Inactive: println("Application was background when event received")
        default: println ("Application was in unknown state: \(application.applicationState.rawValue) when event received")
        }

        let key1Value = notification.userInfo!["Key 1"] as? NSString
        let key2Value = notification.userInfo!["Key 2"] as? NSString
        
        if key1Value != nil && key2Value != nil{
            /* We got our notification */
        } else {
            /* This is not the notification that we composed */
        }
        application.applicationIconBadgeNumber = 0
    }
    
    //MARK: - user functions
    
    func doBackgroundFetch () -> Bool {
        /* Generate a new item */
//        let item = NewsItem( date: NSDate(), text: "News Item \( newsItems.count + 1)")
//        newsItems.append(item)
        /* Send a notification to observers telling them that a news item is now available */
        NSNotificationCenter.defaultCenter().postNotificationName( "doBackgroundFetch", object: self)
        return true
    }
    
    func scheduleLocalNotification(){
        
        let notification = UILocalNotification()
        
        /* Time and timezone settings */
        notification.fireDate = NSDate(timeIntervalSinceNow: 2.0)
        notification.timeZone = NSCalendar.currentCalendar().timeZone
        
        notification.alertBody = "A workflow item you have signed up for has changed"
        // Action settings
        notification.hasAction = true
        notification.alertAction = "View"
        
        /* Badge settings */
        notification.applicationIconBadgeNumber =
            UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        /* Additional information, user info */
        notification.userInfo = [
            "Key 1" : "Value 1",
            "Key 2" : "Value 2"
        ]
        
        /* Schedule the notification */
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func isUserLoggedIn() -> Bool {
        var prefs = NSUserDefaults.standardUserDefaults()
        if  let userId = prefs.valueForKey("USERID") as? String,
            let isLoggedIn = prefs.valueForKey("ISLOGGEDIN") as? Int
            where isLoggedIn as NSNumber == 1 {
                AppDelegate.userId = userId
                AppDelegate.userName = prefs.valueForKey("USERNAME") as? String
                return true
        }
        return false
    }
   
}

