//
//  Login.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/2/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class LoginController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signinTapped(sender : UIButton) {
        var userId = txtUsername.text
        var password = txtPassword.text
        
        if (userId.isEmpty) {
            var alertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else {
            //validate against Firebase, which is asynchronous so we need a callback
            //shorthand for callback,  result is inferred by compiler
//            FirebaseHelper.getUser(userId, completion: { (result) in
//                
//            })
            FirebaseHelper.getUser(userId) { (result) in
                //sender.enabled = true
                if (!result.isEmpty) {
                    println("\(result):\(userId) was authenticated")
                    AppDelegate.userId = userId
                    AppDelegate.userName = result
                    var prefs = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(userId, forKey: "USERID")
                    prefs.setObject(result, forKey: "USERNAME")
                    prefs.setInteger(1, forKey: "ISLOGGEDIN")
                    prefs.synchronize()
                    self.presentViewController(AppDelegate.tabBarController, animated: false, completion: nil)
                }
                else {
                    var alertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = ""
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }
        }
    }
}


