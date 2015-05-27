//
//  FirebaseHelper.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/3/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class FirebaseHelper {
    static let sharedInstance = FirebaseHelper()
    
    var root = Firebase(url: "https://shining-torch-5343.firebaseio.com/wkproto/")
    
    
    //http://fuckingswiftblocksyntax.com/
    
    static func getUser(userId : String, completion: (userName : String) -> Void) {
        var ref = sharedInstance.root.childByAppendingPath("users/\(userId)")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            //println(snapshot)
             println("Firebase users query returned")
            //note we use as! here because it is guaranteed to have something if the event got fired
            completion(userName: snapshot.value["userName"] as! String)
        })
    }
    
    static func getAssignments(userId : String, completion: (assignments : [String:FBAssignment]) -> Void) {
        var ref = sharedInstance.root.childByAppendingPath("assignment/\(userId)")
        var fbAssignments = [String:FBAssignment]()
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            println("Firebase assignments query returned")
            //println(snapshot.key)
            //println(snapshot.value)
            if let tmp = snapshot.value as? [String:NSDictionary] {
                for (assKey,assValues) in tmp {
                    var fbAssn = FBAssignment()
                    fbAssn.key = assKey
                    println(assKey)
                    fbAssn.objectId = assValues["objectId"] as! String
                    fbAssn.objectName = assValues["objectName"] as! String
                    fbAssn.objectType = assValues["objectType"] as! String
                    fbAssn.roleName = assValues["roleName"] as! String
                    fbAssignments[assKey] = fbAssn
                }
            }
            completion(assignments: fbAssignments)
        })
    }
    
    static func getWorkflow(objectId : String, completion: (workflow: [FBWorkflow]) -> Void) {
        var ref = sharedInstance.root.childByAppendingPath("workflow")
        ref.queryOrderedByChild("objectId").queryEqualToValue(objectId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            println("Firebase workflow query returned")
            var wk = [FBWorkflow]()
            if let tmp = snapshot.value as? [String:NSDictionary] {
                //println(tmp)
                for (assKey,assValues) in tmp {
                    let foundObjectId = assValues["objectId"] as! String
                    if (foundObjectId == objectId) {
                        let fbWorkflow = FBWorkflow(key: assKey, objectId: objectId,
                            objectType: assValues["objectType"] as! String,
                            objectName: assValues["objectName"] as! String,
                            beforeState: assValues["beforeState"] as! String,
                            afterState: assValues["afterState"] as! String,
                            userName: assValues["userName"] as! String)
                        wk.append(fbWorkflow)
                    }
                }
            }
            completion(workflow: wk)
        })
    }
    
    static func getWorkflow(objectIds : [String], completion: (workflow: [FBWorkflow]) -> Void) {
        var ref = sharedInstance.root.childByAppendingPath("workflow")
        ref.queryOrderedByChild("objectId").observeSingleEventOfType(.Value, withBlock: { snapshot in
            println("Firebase workflow query returned")
            var wk = [FBWorkflow]()
            if let tmp = snapshot.value as? [String:NSDictionary] {
                //println(tmp)
                for (assKey,assValues) in tmp {
                    let foundObjectId = assValues["objectId"] as! String
                    if find(objectIds,foundObjectId) != nil {
                        let fbWorkflow = FBWorkflow(key: assKey, objectId: foundObjectId,
                            objectType: assValues["objectType"] as! String,
                            objectName: assValues["objectName"] as! String,
                            beforeState: assValues["beforeState"] as! String,
                            afterState: assValues["afterState"] as! String,
                            userName: assValues["userName"] as! String)
                        wk.append(fbWorkflow)
                    }
                }
            }
            completion(workflow: wk)
        })
    }

    
}
