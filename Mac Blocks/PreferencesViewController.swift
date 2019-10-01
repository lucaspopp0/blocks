//
//  PreferencesViewController.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 4/11/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var consoleCheck: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here
    }
    
    @IBAction func connectionStyleChanged(_ sender: NSPopUpButton) {
        Block.connectionStyle = Block.ConnectionStyle(rawValue: sender.titleOfSelectedItem!.lowercased())!
        
        updateWorkspaceBlocks()
    }
    
    @IBAction func blockStyleChanged(_ sender: NSPopUpButton) {
        Block.blockStyle = Block.BlockStyle(rawValue: sender.titleOfSelectedItem!.lowercased())!
        
        updateWorkspaceBlocks()
    }
    
    @IBAction func sizingChanged(_ sender: NSPopUpButton) {
        Block.sizing = Block.Sizing(rawValue: sender.titleOfSelectedItem!.lowercased())!
        
        updateWorkspaceBlocks()
    }
    
    func updateWorkspaceBlocks() {
        for window: NSWindow in NSApplication.shared.windows {
            if let runnerController: RunnerViewController = window.windowController?.contentViewController as? RunnerViewController {
                for block: Block in runnerController.workspaceView.data.blocks {
                    block.layoutObject()
                }
                
                for block: Block in runnerController.sidebarBlocks {
                    block.layoutObject()
                }
            }
        }
    }
    
}
