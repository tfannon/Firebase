//
//  UserSettings.swift
//  WKFirebase
//
//  Created by Tommy Fannon on 4/13/15.
//  Copyright (c) 2015 Crazy8Dev. All rights reserved.
//

let WATCHING = "Watching"


class UserSettings {
    static let sharedInstance = UserSettings()
    var watchedObjects : [String:String] = [:]
    
    //computed property
    var key : String = {
        AppDelegate.userId! + WATCHING
    }()
    
    init() {
        println(__FUNCTION__)
        if let bar = NSUserDefaults.standardUserDefaults().objectForKey(self.key) as? [String:String] {
            self.watchedObjects = bar
            return
        }
    }
    
    func isWatching(objectId : String) -> Bool {
        //println(watchedObjects)
        return watchedObjects[objectId] != nil
    }
    
    func addWatchedObject(objectId : String) {
        watchedObjects[objectId] = objectId
        //println(watchedObjects)
        NSUserDefaults.standardUserDefaults().setObject(watchedObjects, forKey: self.key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func removeWatchedObject(objectId : String) {
        watchedObjects.removeValueForKey(objectId)
        //println(watchedObjects)
        NSUserDefaults.standardUserDefaults().setObject(watchedObjects, forKey: self.key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}