//
//  ViewController.swift
//  FirebaseTest
//
//  Created by Tommy Fannon on 3/28/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Create a reference to a Firebase location
        var myRootRef = Firebase(url:"https://shining-torch-5343.firebaseio.com/users")
      
        // Write data to Firebase
        //myRootRef.setValue("Do you have data? You'll love Firebase.")
        
        // Read all data and react to any changes as they come in
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            println("\(snapshot.key) -> \(snapshot.value)")
        })
        
        //test adding arrays
        //addStructs(myRootRef.childByAppendingPath("arrays"))
        
        //var usersRef = addUsers(myRootRef)
        //updateUser(usersRef)
        query(myRootRef)
    }
    
    func addStructs(ref : Firebase) {
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            println("\(snapshot.key) -> \(snapshot.value)")
        })
        var array = ["a","b","c"]
        var array2 = [1,2,4,6]
        var dictOfArrays = ["first" : array, "second" : array2]
        ref.setValue(dictOfArrays)
    }
    
    
    func query(ref : Firebase) {
        ref.childByAppendingPath("assignment/2502") .observeEventType(FEventType.Value, withBlock: {
            snapshot in
            println("\(snapshot.key) -> \(snapshot.value)")
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addUsers(ref : Firebase) -> Firebase {
        var alanisawesome = ["full_name": "Alan Turing", "date_of_birth": "June 23, 1912"]
        var gracehop = ["full_name": "Grace Hopper", "date_of_birth": "December 9, 1906"]

        var usersRef = ref.childByAppendingPath("users")

        var users = ["alanisawesome": alanisawesome, "gracehop": gracehop]
        usersRef.setValue(users)
        return usersRef
    }
    
    func updateUser(usersRef : Firebase) {
        var hopperRef = usersRef.childByAppendingPath("gracehop")
        var nickname = ["nickname": "Amazing Grace"]
        hopperRef.setValue("I'm writing data", withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if ((error) != nil) {
                println("Data could not be saveed.")
            } else {
                println("Data saved successfully!")
            }
        })
    }
    
   }

