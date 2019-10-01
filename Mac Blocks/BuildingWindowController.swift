//
//  BuildingWindowController.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/26/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The main window controller for the app
class BuildingWindowController: NSWindowController, NSToolbarDelegate {
    
    // The window's toolbar. Contains the run button
    @IBOutlet weak var toolbar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.titleVisibility = NSWindow.TitleVisibility.hidden
        window?.tabbingMode = NSWindow.TabbingMode.preferred
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if itemIdentifier.rawValue == "Run Script" {
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            
            item.label = "Run"
            item.toolTip = "Run Blocks"
            
            let button: NSButton = NSButton(title: "▶︎", target: self, action: #selector(BuildingWindowController.runWorkspaceScript))
            button.bezelStyle = NSButton.BezelStyle.texturedRounded
            button.font = NSFont.systemFont(ofSize: 17)
            
            item.view = button
            
            return item
        } else if itemIdentifier.rawValue == "Right Sidebar" {
            let item: NSToolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            
            let segmentedControl: NSSegmentedControl = NSSegmentedControl(images: [#imageLiteral(resourceName: "Toggle Bottom Panel"), #imageLiteral(resourceName: "Toggle Right Toolbar")], trackingMode: NSSegmentedControl.SwitchTracking.selectAny, target: self, action: #selector(BuildingWindowController.segmentedContolUpdated(_:)))
            
            item.label = "Toggle Sidebars"
            item.toolTip = "Toggle Sidebars"
            
            item.view = segmentedControl
            
            return item
        }
        
        return NSToolbarItem(itemIdentifier: itemIdentifier)
    }
    
    // The identifiers of the existing toolbar items
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier(rawValue: "Run Script"), NSToolbarItem.Identifier.flexibleSpace, NSToolbarItem.Identifier(rawValue: "Right Sidebar")]
    }
    
    // All of the possible identifiers for toolbar items
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier(rawValue: "Run Script"), NSToolbarItem.Identifier.flexibleSpace, NSToolbarItem.Identifier(rawValue: "Right Sidebar")]
    }
    
    @objc func segmentedContolUpdated(_ sender: NSSegmentedControl) {
        let selectedSegment: Int = sender.selectedSegment
        
        if selectedSegment == 0 {
            if sender.isSelected(forSegment: selectedSegment) {
                (contentViewController as? RunnerViewController)?.openConsole(self)
            } else {
                (contentViewController as? RunnerViewController)?.closeConsole(self)
            }
        } else if selectedSegment == 1 {
            if sender.isSelected(forSegment: selectedSegment) {
                (contentViewController as? RunnerViewController)?.openSidebar(self)
            } else {
                (contentViewController as? RunnerViewController)?.closeSidebar(self)
            }
        }
    }
    
    // Called when the run button is pressed
    @objc func runWorkspaceScript() {
        if let shouldClear: Bool = NSUserDefaultsController.shared.value(forKeyPath: "values.automaticallyClearsConsole") as? Bool {
            if shouldClear {
                (contentViewController as? RunnerViewController)?.clearConsole(self)
            }
        }
        
        (contentViewController as? RunnerViewController)?.workspaceView.run()
    }
    
}
