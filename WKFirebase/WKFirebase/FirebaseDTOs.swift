//
//  FirebaseDTOs.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/11/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

class FBUser {
    var userId : Int = 0
    var userName : String = ""
}

class FBAssignment {
    var key : String = ""
    var objectId : String = ""
    var objectName : String = ""
    var objectType : String = ""
    var roleName : String = ""
}

class FBWorkflow {
    var key : String
    var objectId : String
    var objectType : String
    var objectName : String
    var beforeState : String
    var afterState : String
    var userName : String
    
    init(key : String, objectId : String, objectType : String, objectName : String, beforeState : String, afterState : String, userName : String) {
        self.key = key
        self.objectId = objectId
        self.objectType = objectType
        self.objectName = objectName
        self.beforeState = beforeState
        self.afterState = afterState
        self.userName = userName
    }
}