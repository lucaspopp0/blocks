//
//  ClassViewController.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class ClassViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource, ExtendedTableViewDelegate, NSTableViewDataSource, WorkspaceDelegate {
    func didPlaceBlock(_ block: Block) {
        
    }

    
    @IBOutlet weak var classNameField: NSTextField!
    @IBOutlet weak var methodPropertyOutlineView: NSOutlineView!
    @IBOutlet weak var splitView: NSSplitView!
    
    let propertyEditView: PropertyEditView = PropertyEditView(frame: CGRect.zero)
    
    let sideSplitView: NSSplitView = NSSplitView()
    let workspaceView: WorkspaceView = WorkspaceView(frame: CGRect.zero)
    let blockEditView: BlockEditView = BlockEditView(frame: CGRect.zero)
    let scrollView: NSScrollView = NSScrollView()
    let tableView: NSTableView = NSTableView()
    
    
    let sidebarBlocks: [Block] = [PrintBlock(),
                                  BooleanBlock(), EqualityTestBlock(), AndOrBlock(), IfBlock(), NotBlock(),
                                  CountLoopBlock(), WhileUntilLoopBlock(), SkipLoopBlock(),
                                  NumberInputBlock(), ArithmeticBlock(), ComplexOperationBlock(), TrigOperationBlock(), ConstantBlock(), EvenOddBlock(), RoundBlock(), RandomFractionBlock(), RandomBetweenBlock(),
                                  TextInputBlock(), TextLengthBlock(), FindInTextBlock(), CharAtBlock(), SubstringBlock(), TextCaseBlock(), SplitStringBlock(),
                                  ObjectBlock(), SetObjectPropertyBlock(), RemoveObjectPropertyBlock(),
                                  ListBlock(), ListLengthBlock(), FindInListBlock(), ListItemAtIndexBlock(), SetItemInListBlock(), InsertItemInListBlock(), AddToListBlock(),
                                  TypeBlock(), TypeOfBlock(), TypeIsBlock(), AsBlock(),
                                  VariableInitializerBlock(), VariableGetterBlock(), VariableSetterBlock()]
    
    var data: ClassData = ClassData() {
        didSet {}
    }
    
    override func awakeFromNib() {
        sideSplitView.isVertical = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for block: Block in sidebarBlocks {
            block.frame.origin.x = WorkspaceView.PADDING
            block.frame.origin.y = WorkspaceView.PADDING / 2
        }
        
        sidebarBlocks.last?.frame.origin.y += WorkspaceView.PADDING
        
        sideSplitView.dividerStyle = NSSplitView.DividerStyle.thin
        
        sideSplitView.addArrangedSubview(blockEditView)
        scrollView.documentView = tableView
        sideSplitView.addArrangedSubview(scrollView)
        
        scrollView.borderType = NSBorderType.noBorder
        scrollView.drawsBackground = false
        
        tableView.headerView = nil
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = NSColor.clear
        
        tableView.reloadData()
        
        sideSplitView.addConstraint(NSLayoutConstraint(item: sideSplitView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 260))
        
        sideSplitView.isVertical = true
        sideSplitView.adjustSubviews()
        sideSplitView.setNeedsDisplay(sideSplitView.frame)
        
        if data.properties.count > 0 {
            methodPropertyOutlineView.selectRowIndexes(IndexSet(integer: 1), byExtendingSelection: false)
        }
    }
    
    @IBAction func newProperty(_ sender: Any) {
    }
    
    @IBAction func newMethod(_ sender: Any) {
    }
    
    // MARK: Outline view delegate
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            var items: Int = 0
            
            items += 2                       // Headers
            items += 1                       // Padding between sections
            items += data.properties.count   // Properties
            items += data.methods.count      // Methods
            
            return items
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if outlineView.isEqual(methodPropertyOutlineView) {
            var output: [String: String] = ["title": "", "subtitle" : "", "identifier": "DataCell"]
            
            if index == 0 {
                output["title"] = "PROPERTIES"
                output["identifier"] = "HeaderCell"
            } else if index < 1 + data.properties.count {
                output["title"] = data.properties[index - 1].name
                output["subtitle"] = String(describing: data.properties[index - 1].type)
            } else if index == 1 + data.properties.count {
                output["identifier"] = "BlankCell"
            } else if index == 2 + data.properties.count {
                output["title"] = "METHODS"
                output["identifier"] = "HeaderCell"
            } else {
                output["title"] = data.methods[index - 3 - data.properties.count].name
                output["subtitle"] = String(describing: data.methods[index - 3 - data.properties.count].outputType)
            }
            
            return output
        }
        
        return ""
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if outlineView.isEqual(methodPropertyOutlineView) && item is [String: String] {
            let dict: [String: String] = item as! [String: String]
            let view: NSTableCellView? = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: dict["identifier"]!), owner: self) as? NSTableCellView
            
            if view != nil {
                if dict["identifier"]! == "DataCell" {
                    for subview: NSView in view!.subviews {
                        if subview.identifier != nil && subview.identifier!.rawValue == "NameField" {
                            (subview as! NSTextField).stringValue = dict["title"]!
                        } else if subview.identifier != nil && subview.identifier!.rawValue == "TypeField" {
                            (subview as! NSTextField).stringValue = dict["subtitle"]!
                        }
                    }
                } else {
                    view!.textField?.stringValue = dict["title"]!
                }
            }
            
            return view
        }
        
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let dict: [String: String] = item as? [String: String] {
            if dict["identifier"]! == "DataCell" {
                return true
            }
            
            return false
        }
        
        return true
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        let mpRow: Int = methodPropertyOutlineView.selectedRow
        
        if mpRow > 0 && mpRow <= data.properties.count {
            if splitView.arrangedSubviews.contains(workspaceView) {
                splitView.removeArrangedSubview(workspaceView)
                workspaceView.removeFromSuperview()
            }
            
            if splitView.arrangedSubviews.contains(sideSplitView) {
                splitView.removeArrangedSubview(sideSplitView)
                sideSplitView.removeFromSuperview()
            }
            
            if !splitView.arrangedSubviews.contains(propertyEditView) {
                splitView.addArrangedSubview(propertyEditView)
            }
        } else if mpRow > 2 + data.properties.count && mpRow <= 2 + data.properties.count + data.methods.count {
            if splitView.arrangedSubviews.contains(propertyEditView) {
                splitView.removeArrangedSubview(propertyEditView)
                propertyEditView.removeFromSuperview()
            }
            
            if !splitView.arrangedSubviews.contains(workspaceView) {
                splitView.addArrangedSubview(workspaceView)
            }
            
            if !splitView.arrangedSubviews.contains(sideSplitView) {
                splitView.addArrangedSubview(sideSplitView)
            }
        }
    }
    
    // MARK: Table View Delegate
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.isEqual(self.tableView) {
            return sidebarBlocks.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView.isEqual(self.tableView) {
            let container: NSView = NSView()
            container.addSubview(sidebarBlocks[row])
            
            return container
        }
        
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if tableView.isEqual(self.tableView) {
            if row == 0 || row == sidebarBlocks.count - 1 {
                return sidebarBlocks[row].frame.size.height + (2 * WorkspaceView.PADDING)
            } else {
                return sidebarBlocks[row].frame.size.height + WorkspaceView.PADDING
            }
        }
        
        return 0
    }
    
    func blockSelected(_ block: Block?) {
        blockEditView.block = block
    }
    
    @nonobjc func tableView(_ tableView: NSTableView, didClickRow row: Int) {
        workspaceView.beginPlacingBlock(type(of: sidebarBlocks[row]).init(origin: CGPoint(x: 2 * WorkspaceView.PADDING, y: 2 * WorkspaceView.PADDING)))
    }
    
}
