//
//  ChatController.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/15/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//


class ChatController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var objectName: UILabel!
    
    var firebase : Firebase!
    var chat: NSMutableArray = NSMutableArray()
    
    
    override func viewWillAppear(animated: Bool) {
        chat.removeAllObjects()
        self.tableView.reloadData()
        if let selectedObject = AppDelegate.selectedObjectId {
            self.objectName.text = AppDelegate.selectedObjectName

            firebase = FirebaseHelper.sharedInstance.root.childByAppendingPath("/chat/\(selectedObject)")
            self.firebase.observeEventType(.ChildAdded, withBlock: {snapshot in
                self.chat.addObject(snapshot.value)
                self.tableView.reloadData()
            })
        }
        //listen for keyboard events which are fired when using clicks on text field
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //these remove our listeners
    override func viewWillDisappear(animated: Bool) {
        if firebase != nil {
            firebase.removeAllObservers()
        }
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }
    

    //MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.chat.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clearColor()
        var rowData = self.chat[indexPath.row] as! NSDictionary
        //these are defaults for UITableViewCell
        cell.textLabel!.text = rowData["text"] as? String
        cell.detailTextLabel!.text = rowData["name"] as? String
        return cell
    }
    
    //MARK: - Keyboard
    func keyboardWillShow(notification: NSNotification) {
        self.moveView(notification.userInfo!, up: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.moveView(notification.userInfo!, up: false)
    }
    
    func moveView(userInfo: NSDictionary, up: Bool) {
        var keyboardEndFrame: CGRect = CGRect()
        userInfo[UIKeyboardFrameEndUserInfoKey]!.getValue(&keyboardEndFrame)
        
        var animationCurve: UIViewAnimationCurve = UIViewAnimationCurve.EaseOut
        userInfo[UIKeyboardAnimationCurveUserInfoKey]!.getValue(&animationCurve)
        
        var animationDuration: NSTimeInterval = NSTimeInterval()
        userInfo[UIKeyboardAnimationDurationUserInfoKey]!.getValue(&animationDuration)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        var keyboardFrame: CGRect = self.view.convertRect(keyboardEndFrame, toView: nil)
        var y = keyboardFrame.size.height * (up ? -1 : 1)
        self.view.frame = CGRectOffset(self.view.frame, 0, y)
        
        UIView.commitAnimations()
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.endEditing(true)
        self.firebase.childByAutoId().setValue(["name": AppDelegate.userName, "text": message.text])
        textField.text = ""
        return false
    }
}
