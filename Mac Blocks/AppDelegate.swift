//
//  AppDelegate.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

/*
 
 TODO: Todo list
 - Double click slot inputs for default input (ex: double click "text" in print block for a new blank text block)
 
 */

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupDefaults()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func setupDefaults() {
        let defaults: UserDefaults = UserDefaults.standard
        
        var alreadyOpened: Bool = false
        
        if let opened: Bool = defaults.value(forKey: "Already Opened") as? Bool {
            alreadyOpened = opened
        }
        
        if !alreadyOpened {
            Swift.print("Not opened yet")
        }
        
//        defaults.set(true, forKey: "Already Opened")
        defaults.synchronize()
        
        NSUserDefaultsController.shared.initialValues = [
            "automaticallyClearsConsole" : false,
            "connectionStyle" : "Trapezoid",
            "blockStyle" : "Rounded",
            "sizing" : "Comfortable"
        ]
        
        if let connectionStyle: String = NSUserDefaultsController.shared.value(forKeyPath: "values.connectionStyle") as? String {
            Block.connectionStyle = Block.ConnectionStyle(rawValue: connectionStyle.lowercased())!
        }
        
        if let blockStyle: String = NSUserDefaultsController.shared.value(forKeyPath: "values.blockStyle") as? String {
            Block.blockStyle = Block.BlockStyle(rawValue: blockStyle.lowercased())!
        }
        
        if let sizing: String = NSUserDefaultsController.shared.value(forKeyPath: "values.sizing") as? String {
            Block.sizing = Block.Sizing(rawValue: sizing.lowercased())!
        }
    }

}

