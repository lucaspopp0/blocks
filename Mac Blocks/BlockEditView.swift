//
//  BlockEditView.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/16/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Displays and modifies properties of editable blocks
class BlockEditView: NSView {
    
    // Used to constrain the height of the view
    // TODO: heightConstraint is handled sloppily. Update to modify the constant so it's more elegant
    var heightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // Border below the rowView
    let separator: NSBox = NSBox()
    
    let label: NSTextField = NSTextField(labelWithString: "No block selected")
    let rowView: RowView = RowView()
    
    // The block being edited
    var block: Block? {
        didSet {
            adjustPosition()
        }
    }
    
    override var isFlipped: Bool {
        get {
            return true
        }
    }
    
    func unifiedInit() {
        addSubview(label)
        addSubview(rowView)
        addSubview(separator)
        
        label.alignment = NSTextAlignment.center
        label.textColor = NSColor.secondaryLabelColor
        label.sizeToFit()
        
        separator.boxType = NSBox.BoxType.separator
        
        adjustPosition()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        unifiedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        unifiedInit()
    }
    
    func adjustPosition() {
        let previousHeight: CGFloat = bounds.size.height
        
        if constraints.contains(heightConstraint) {
            removeConstraint(heightConstraint)
        }
        
        rowView.reloadData()
        
        if block != nil {
            label.removeFromSuperview()
            addSubview(rowView)
            addSubview(separator)
            
            rowView.shrinkHeightToRows()
            
            rowView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: rowView.frame.size.height)
            separator.frame = CGRect(x: 0, y: rowView.frame.size.height, width: bounds.size.width, height: 1)
            
            heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: rowView.frame.size.height)
            
            if rowView.numberOfRows(inRowView: rowView) == 0 {
                rowView.removeFromSuperview()
                separator.removeFromSuperview()
            }
        } else {
            rowView.removeFromSuperview()
            separator.removeFromSuperview()
            addSubview(label)
            
            label.sizeToFit()
            heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: label.frame.size.height + 40)
        }
        
        addConstraint(heightConstraint)
        layout()
        
        if block == nil {
            label.frame = CGRect(x: 0, y: max(20, (bounds.size.height - label.frame.size.height) / 2, (previousHeight - label.frame.size.height) / 2), width: bounds.size.width, height: label.frame.size.height)
        }
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        adjustPosition()
    }
    
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        
        adjustPosition()
    }
    
}
