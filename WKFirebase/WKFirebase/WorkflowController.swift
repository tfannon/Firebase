//
//  SecondViewController.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/1/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class WorkflowController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var workflow = [FBWorkflow]()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.yellowColor()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if AppDelegate.wasAssignmentSelected {
            if let selectedObjectId = AppDelegate.selectedObjectId {
                FirebaseHelper.getWorkflow(selectedObjectId, completion: { (result) in
                    println(result)
                    self.workflow = result as [FBWorkflow]
                    self.tableView.reloadData()
                })
            }
        }
        else {
            var watchedObjects = UserSettings.sharedInstance.watchedObjects.values.array as [String]
            FirebaseHelper.getWorkflow(watchedObjects, completion: { (result) in
                println(result)
                self.workflow = result as [FBWorkflow]
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workflow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("WorkflowCell",
            forIndexPath: indexPath) as! WorkflowCell
        cell.backgroundColor = UIColor.clearColor()
        cell.objectName.text = workflow[indexPath.row].objectName
        cell.previousState.text = ("was \(workflow[indexPath.row].beforeState)")
        cell.changedBy.text = ("changed by \(workflow[indexPath.row].userName)")
        var state = workflow[indexPath.row].afterState
        cell.newState.text = state
        //set the icon based on the state
        switch (state) {
            case "Completed": cell.stateIcon.image = UIImage(named: "completed")
            case "In Progress" : cell.stateIcon.image = UIImage(named: "in-progress")
            case "Reviewed" :cell.stateIcon.image = UIImage(named: "reviewed")
            case "Not Started" :cell.stateIcon.image = UIImage(named: "not-started")
            default: ""
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    //selecting on the row will fetch the object we are on, and switch to the chat room
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //find the cell selected and change its checkbox state
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! WorkflowCell
        AppDelegate.selectedObjectId = workflow[indexPath.row].objectId
        AppDelegate.selectedObjectName = workflow[indexPath.row].objectName
        
        //dont keep the row selected
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //now we switch the tabbar manually to chat
        self.tabBarController?.selectedIndex = 2
    }

}

