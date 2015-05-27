//
//  FirstViewController.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/1/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class AssignmentsController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    //declaring something with a ! means you know its going to be initialized before use, but outside of the initializer
    @IBOutlet weak var tableView: UITableView!
    
    //delaring with a ? means it needs to be nullchecked
    var fbAssignments : [FBAssignment]?

    //MARK: - Actions
    //we trap the checkbox tapped event, get the position where its out and calculate the indexpath
    @IBAction func checkboxTapped(sender: Checkbox, forEvent event: UIEvent) {
        let aTouch = event.allTouches()!.first as! UITouch
        let currentPos = aTouch.locationInView(self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(currentPos) {
            persistCheckbox(sender, indexPath: indexPath)
        }
    }
    
    //MARK:  - UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.yellowColor()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        FirebaseHelper.getAssignments(AppDelegate.userId!, completion: { (result) in
            self.fbAssignments = result.values.array as [FBAssignment]
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    //MARK: - UITableviewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fbAssignments != nil {
            return fbAssignments!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AssignmentCell",
            forIndexPath: indexPath) as! AssignmentCell

        cell.objectName.text = fbAssignments![indexPath.row].objectName
        cell.roleName.text = fbAssignments![indexPath.row].roleName
        cell.checkbox.checked = UserSettings.sharedInstance.isWatching(fbAssignments![indexPath.row].objectId)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    //if they touch anywhere on the row treat this as checking the box
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //find the cell selected and change its checkbox state
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! AssignmentCell
        AppDelegate.selectedObjectId = fbAssignments![indexPath.row].objectId
        AppDelegate.selectedObjectName = fbAssignments![indexPath.row].objectName
        AppDelegate.wasAssignmentSelected = true

        //selecting the row will also add the object to list of watched objects
        cell.checkbox.checked = true
        persistCheckbox(cell.checkbox, indexPath:indexPath)
        
        //dont keep the row selected
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //now we switch the tabbar manually to workflow
        self.tabBarController?.selectedIndex = 1
    }
    
    //MARK: - helpers
    func persistCheckbox(checkbox : Checkbox, indexPath : NSIndexPath) {
        if checkbox.checked {
            UserSettings.sharedInstance.addWatchedObject(fbAssignments![indexPath.row].objectId)
        } else {
            UserSettings.sharedInstance.removeWatchedObject(fbAssignments![indexPath.row].objectId)
        }
    }
}


