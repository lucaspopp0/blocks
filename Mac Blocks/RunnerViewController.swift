//
//  RunnerViewController.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/4/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class RunnerViewController: NSViewController, ExtendedTableViewDelegate, NSTableViewDataSource, WorkspaceDelegate, NSSplitViewDelegate, RowViewDelegate {
    
    var rowViews: [RowView] = []
    
    var rightSidebarControl: NSSegmentedControl?
    
    @IBOutlet weak var workspaceView: WorkspaceView!
    @IBOutlet weak var consoleView: ConsoleView!
    @IBOutlet weak var blockEditView: BlockEditView!
    @IBOutlet weak var blockDrawerTableView: NSTableView!
    
    @IBOutlet weak var editViewSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var blockDrawerSegmentedControl: CustomSegmentedControl!
    
    @IBOutlet weak var horizontalSplitView: NSSplitView!
    @IBOutlet weak var leftVerticalSplitView: NSSplitView!
    @IBOutlet weak var rightVerticalSplitView: NSSplitView!
    
    // List of blocks to display in the table view
    let sidebarBlocks: [Block] = [PrintBlock(), PromptBlock(),
                                  BooleanBlock(), EqualityTestBlock(), AndOrBlock(), IfBlock(), NotBlock(),
                                  CountLoopBlock(), WhileUntilLoopBlock(), SkipLoopBlock(),
                                  NumberInputBlock(), ArithmeticBlock(), ComplexOperationBlock(), TrigOperationBlock(), ConstantBlock(), EvenOddBlock(), RoundBlock(), RandomFractionBlock(), RandomBetweenBlock(),
                                  TextInputBlock(), ConcatenateTextBlock(), TextLengthBlock(), FindInTextBlock(), CharAtBlock(), SubstringBlock(), TextCaseBlock(), SplitStringBlock(),
                                  ObjectBlock(), GetObjectPropertyBlock(), SetObjectPropertyBlock(), RemoveObjectPropertyBlock(),
                                  ListBlock(), ListLengthBlock(), FindInListBlock(), ListItemAtIndexBlock(), SetItemInListBlock(), InsertItemInListBlock(), AddToListBlock(),
                                  TypeBlock(), TypeOfBlock(), TypeIsBlock(), AsBlock(),
                                  VariableInitializerBlock(), VariableInitialValueBlock(), VariableGetterBlock(), VariableSetterBlock(),
                                  WindowBlock(), OpenWindowBlock(),
                                  ColorBlock(), PresetColorBlock(), RGBColorBlock()]
    
    var recentBlocks: [Block] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editViewSegmentedControl.wantsLayer = true
        editViewSegmentedControl.layer?.backgroundColor = NSColor.white.cgColor
        
        editViewSegmentedControl.addSegment(withTitle: "About")
        editViewSegmentedControl.addSegment(withTitle: "Edit")
        editViewSegmentedControl.addSegment(withTitle: "Help")
        
        editViewSegmentedControl.setEnabled(segment: 0, enabled: false)
        editViewSegmentedControl.setEnabled(segment: 1, enabled: false)
        editViewSegmentedControl.setEnabled(segment: 2, enabled: false)
        
        blockDrawerSegmentedControl.wantsLayer = true
        blockDrawerSegmentedControl.layer?.backgroundColor = NSColor.white.cgColor
        
        blockDrawerSegmentedControl.addSegment(withTitle: "Recent (0)")
        blockDrawerSegmentedControl.addSegment(withTitle: "All")
        
        blockDrawerSegmentedControl.setEnabled(segment: 0, enabled: true)
        blockDrawerSegmentedControl.setEnabled(segment: 1, enabled: true)
        
        blockDrawerSegmentedControl.selectedIndex = 1
        
        for block: Block in sidebarBlocks {
            block.frame.origin.x = WorkspaceView.PADDING
            block.frame.origin.y = WorkspaceView.PADDING / 2
        }
        
        sidebarBlocks.last?.frame.origin.y += WorkspaceView.PADDING
        
        workspaceView.delegate = self
        workspaceView.console.view = consoleView
        
        blockEditView.rowView.delegate = self
        
        blockDrawerTableView.delegate = self
        blockDrawerTableView.dataSource = self
        blockDrawerTableView.setupGestures()
        
        horizontalSplitView.delegate = self
        leftVerticalSplitView.delegate = self
        
        horizontalSplitView.setPosition(view.frame.size.width - 260, ofDividerAt: 0)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        for block: Block in sidebarBlocks {
            block.layoutObject()
        }
        
        for block: Block in recentBlocks {
            block.layoutObject()
        }
    }
    
    @IBAction func clearConsole(_ sender: Any) {
        consoleView.clear()
    }
    
    func openSidebar(_ sender: Any) {
        horizontalSplitView.setPosition(horizontalSplitView.frame.size.width - 500, ofDividerAt: 0)
    }
    
    func closeSidebar(_ sender: Any) {
        horizontalSplitView.setPosition(horizontalSplitView.frame.size.width, ofDividerAt: 0)
    }
    
    func openConsole(_ sender: Any) {
        leftVerticalSplitView.setPosition(leftVerticalSplitView.frame.size.height - 300, ofDividerAt: 0)
    }
    
    func closeConsole(_ sender: Any) {
        leftVerticalSplitView.setPosition(leftVerticalSplitView.frame.size.height, ofDividerAt: 0)
    }
    
    @IBAction func editControlTabChange(_ sender: CustomSegmentedControl) {
        blockEditView.adjustPosition()
    }
    
    @IBAction func drawerControlTabChange(_ sender: CustomSegmentedControl) {
        blockDrawerTableView.reloadData()
    }
    
    // MARK: WorkspaceDelegate
    
    func blockSelected(_ block: Block?) {
        if block == nil {
            editViewSegmentedControl.selectedIndex = nil
            
            editViewSegmentedControl.setEnabled(segment: 0, enabled: false)
            editViewSegmentedControl.setEnabled(segment: 1, enabled: false)
            editViewSegmentedControl.setEnabled(segment: 2, enabled: false)
        } else {
            editViewSegmentedControl.setEnabled(segment: 0, enabled: true)
            editViewSegmentedControl.setEnabled(segment: 1, enabled: block!.numberOfRows(inRowView: blockEditView.rowView) > 0)
            editViewSegmentedControl.setEnabled(segment: 2, enabled: false)
            
            if editViewSegmentedControl.selectedIndex == nil || !editViewSegmentedControl.isEnabled(segment: editViewSegmentedControl.selectedIndex!) {
                editViewSegmentedControl.selectedIndex = 0
            }
        }
        
        blockEditView.block = block
    }
    
    func didPlaceBlock(_ block: Block) {
        let blockType: String = String(describing: type(of: block))
        
        for recentBlock: Block in recentBlocks {
            if blockType == String(describing: type(of: recentBlock)) {
                return
            }
        }
        
        if let template: Block = Block.constructFromType(String(describing: type(of: block))) {
            recentBlocks.insert(template, at: 0)
            
            while recentBlocks.count > 10 {
                recentBlocks.remove(at: 10)
            }
            
            for recentBlock: Block in recentBlocks {
                recentBlock.frame.origin.x = WorkspaceView.PADDING
                recentBlock.frame.origin.y = WorkspaceView.PADDING / 2
            }
            
            recentBlocks.last?.frame.origin.y += WorkspaceView.PADDING
            
            blockDrawerSegmentedControl.setTitle(title: "Recent (\(recentBlocks.count))", ofSegment: 0)
            
            blockDrawerTableView.reloadData()
        }
    }
    
    // MARK: ExtendedTableViewDelegate
    
    @nonobjc func tableView(_ tableView: NSTableView, didClickRow row: Int) {
        if let tabIndex: Int = blockDrawerSegmentedControl.selectedIndex {
            if tabIndex == 0 {
                workspaceView.beginPlacingBlock(type(of: recentBlocks[row]).init(origin: CGPoint(x: 2 * WorkspaceView.PADDING, y: 2 * WorkspaceView.PADDING)))
            } else {
                workspaceView.beginPlacingBlock(type(of: sidebarBlocks[row]).init(origin: CGPoint(x: 2 * WorkspaceView.PADDING, y: 2 * WorkspaceView.PADDING)))
            }
        }
    }
    
    // MARK: NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.isEqual(blockDrawerTableView) {
            if let tabIndex: Int = blockDrawerSegmentedControl.selectedIndex {
                if tabIndex == 0 {
                    return recentBlocks.count
                } else if tabIndex == 1 {
                    return sidebarBlocks.count
                }
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView.isEqual(blockDrawerTableView) {
            if let tabIndex: Int = blockDrawerSegmentedControl.selectedIndex {
                let container: NSView = NSView()
                
                if tabIndex == 0 {
                    container.addSubview(recentBlocks[row])
                } else if tabIndex == 1 {
                    container.addSubview(sidebarBlocks[row])
                }
                
                return container
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if tableView.isEqual(blockDrawerTableView) {
            if let tabIndex: Int = blockDrawerSegmentedControl.selectedIndex {
                if tabIndex == 0 {
                    if row == 0 || row == recentBlocks.count - 1 {
                        return recentBlocks[row].frame.size.height + (2 * WorkspaceView.PADDING)
                    } else {
                        return recentBlocks[row].frame.size.height + WorkspaceView.PADDING
                    }
                } else if tabIndex == 1 {
                    if row == 0 || row == sidebarBlocks.count - 1 {
                        return sidebarBlocks[row].frame.size.height + (2 * WorkspaceView.PADDING)
                    } else {
                        return sidebarBlocks[row].frame.size.height + WorkspaceView.PADDING
                    }
                }
            }
        }
        
        return 44
    }
    
    // MARK: NSSplitViewDelegate
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        if splitView.isEqual(horizontalSplitView) {
            return 260
        } else {
            return proposedMinimumPosition
        }
    }
    
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        if splitView.isEqual(horizontalSplitView) {
            return horizontalSplitView.frame.size.width - 260
        } else {
            return proposedMaximumPosition
        }
    }
    
    func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        if splitView.isEqual(horizontalSplitView) {
            if let index: Int = splitView.subviews.index(of: subview) {
                if index == 1 {
                    return true
                }
            }
        } else if splitView.isEqual(leftVerticalSplitView) {
            if let index: Int = splitView.subviews.index(of: subview) {
                if index == 1 {
                    return true
                }
            }
        }
        
        return false
    }
    
    func splitView(_ splitView: NSSplitView, shouldCollapseSubview subview: NSView, forDoubleClickOnDividerAt dividerIndex: Int) -> Bool {
        return true
    }
    
    func splitViewDidResizeSubviews(_ notification: Notification) {
        if rightSidebarControl == nil {
            if let toolbarItems = (view.window?.windowController as? BuildingWindowController)?.toolbar.items {
                for item in toolbarItems {
                    if item.itemIdentifier.rawValue == "Right Sidebar" {
                        rightSidebarControl = item.view as? NSSegmentedControl
                        break
                    }
                }
            }
        }
        
        rightSidebarControl?.setSelected(!leftVerticalSplitView.isSubviewCollapsed(leftVerticalSplitView.subviews[1]), forSegment: 0)
        rightSidebarControl?.setSelected(!horizontalSplitView.isSubviewCollapsed(horizontalSplitView.subviews[1]), forSegment: 1)
    }
    
    // MARK: RowViewDelegate
    
    func numberOfRows(inRowView rowView: RowView) -> Int {
        if editViewSegmentedControl.selectedIndex == 0 {
            if workspaceView.selectedBlock != nil {
                return 2
            } else {
                return 0
            }
        } else {
            return workspaceView.selectedBlock?.numberOfRows(inRowView: rowView) ?? 0
        }
    }
    
    func heightOf(row: Int, inRowView rowView: RowView) -> CGFloat {
        if editViewSegmentedControl.selectedIndex == 0 {
            if row == 0 {
                return 30
            } else if row == 1 {
                let heading: NSTextField = NSTextField(labelWithString: "Description")
                heading.sizeToFit()
                
                let textView: NSTextView = NSTextView()
                textView.string = workspaceView.selectedBlock!.blockDescription
                
                textView.frame.size.width = rowView.frame.size.width - 20
                textView.font = heading.font
                
                textView.sizeToFit()
                
                return heading.frame.size.height + textView.frame.size.height + 25
            }
        } else {
            return workspaceView.selectedBlock?.heightOf(row: row, inRowView: rowView) ?? 30
        }
        
        return 30
    }
    
    func viewFor(row: Int, inRowView rowView: RowView) -> NSView? {
        if editViewSegmentedControl.selectedIndex == 0 {
            let genericView: NSView = NSView()
            
            let heading: NSTextField = NSTextField(labelWithString: "")
            
            if row == 0 {
                heading.stringValue = "Outputs"
                
                let outputTypeIndicator: NSTextField = NSTextField(labelWithString: String(describing: workspaceView.selectedBlock!.outputType))
                
                outputTypeIndicator.alignment = NSTextAlignment.right
                outputTypeIndicator.textColor = NSColor.secondaryLabelColor
                
                heading.sizeToFit()
                heading.frame = CGRect(x: 10, y: (heightOf(row: row, inRowView: rowView) - heading.frame.size.height) / 2, width: min(heading.frame.size.width, rowView.bounds.size.width - 20), height: heading.frame.size.height)
                
                outputTypeIndicator.sizeToFit()
                let indicatorWidth: CGFloat = min(outputTypeIndicator.bounds.size.width, rowView.bounds.size.width - 20 - heading.bounds.size.width)
                outputTypeIndicator.frame = CGRect(x: rowView.bounds.size.width - 10 - indicatorWidth, y: (heightOf(row: row, inRowView: rowView) - heading.frame.size.height) / 2, width: indicatorWidth, height: heading.frame.size.height)
                
                genericView.addSubview(heading)
                genericView.addSubview(outputTypeIndicator)
                
                return genericView
            } else if row == 1 {
                heading.stringValue = "Description"
                
                genericView.addSubview(heading)
                
                heading.sizeToFit()
                heading.frame = CGRect(x: 10, y: heightOf(row: row, inRowView: rowView) - heading.frame.size.height - 5, width: min(heading.frame.size.width, rowView.bounds.size.width - 20), height: heading.frame.size.height)
                
                let textView: NSTextView = NSTextView()
                textView.string = workspaceView.selectedBlock!.blockDescription
                
                textView.frame.size.width = rowView.frame.size.width - 20
                textView.textContainerInset = NSSize.zero
                textView.font = heading.font
                textView.isEditable = false
                textView.isSelectable = false

                textView.sizeToFit()
                
                textView.frame = CGRect(x: 8, y: 10, width: rowView.frame.size.width - 16, height: textView.frame.size.height)
                
                genericView.addSubview(textView)
                
                return genericView
            }
            
            return nil
        } else {
            return workspaceView.selectedBlock?.viewFor(row: row, inRowView: rowView) ?? nil
        }
    }
    
}
