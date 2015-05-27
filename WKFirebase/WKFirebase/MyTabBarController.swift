//
//  MyTabBarController.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/2/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class MyTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIButton(frame: CGRectMake(6, 23, 100, 25))
        addButton.setTitle("Logout", forState: .Normal)
        //same as login button (you can find it in the storyboard source)
        addButton.backgroundColor = UIColor(red: 0.0, green: 0.47843137250000001, blue: 1, alpha: 1)
        addButton.addTarget(self, action: "logout", forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton)
        
        let addLabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width-146, 23, 140, 25))
        addLabel.text = AppDelegate.userName
        addLabel.textAlignment = .Right
        self.view.addSubview(addLabel)
        
        //listen for my own tabbar events
        self.delegate = self
    }
    
    //prevent the user from navigating directly to workflow
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        //we dont want the user navigating to workflow or chat without first selecting an object
//        if tabBarController.selectedIndex == 0 && AppDelegate.selectedObjectId == nil {
//            return false
//        }
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        //if they have clicked on workflow manually, we will store this so we can show all objects, not just a single row
        if viewController is WorkflowController {
            AppDelegate.wasAssignmentSelected = false
        }
    }
    
    
    
    func logout() {
//        self.dismissViewControllerAnimated(false, completion: nil)
        AppDelegate.userName = nil
        var prefs = NSUserDefaults.standardUserDefaults()
        prefs.removeObjectForKey("USER")
        prefs.removeObjectForKey("ISLOGGEDIN")
        prefs.synchronize()
        self.presentViewController(AppDelegate.loginController, animated: false, completion: nil)
    }
}
