//
//  RowView.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/23/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

/*
 
 The files here were created specifically for BlockEditView. Every block has a few constant
 properties that always show up here, and the rest all have different properties to edit depending
 on the block. RowViewDelegate is used to provide the default properties, and ExtendedRowViewDelegate
 specifies the extra, block-specific, properties
 
 */

protocol RowViewDelegate {
    
    var rowViews: [RowView] { get set }
    
    func numberOfRows(inRowView rowView: RowView) -> Int
    func heightOf(row: Int, inRowView rowView: RowView) -> CGFloat
    func viewFor(row: Int, inRowView rowView: RowView) -> NSView?
    
}

// Delegate for adding extra rows (in addition to the default ones provided by RowViewDelegate)
protocol ExtendedRowViewDelegate {
    
    func numberOfExtraRows(inRowView rowView: RowView) -> Int
    func heightOf(extraRow row: Int, inRowView rowView: RowView) -> CGFloat
    func viewFor(extraRow row: Int, inRowView rowView: RowView) -> NSView?
    
}

// Similar to an NSTableView, but only with one column. Simpler to work with
class RowView: NSView {
    
    var delegate: RowViewDelegate? {
        willSet {
            if let index: Int = delegate?.rowViews.index(of: self) {
                delegate!.rowViews.remove(at: index)
            }
        }
        
        didSet {
            reloadData()
            
            if delegate != nil {
                if !delegate!.rowViews.contains(self) {
                    delegate!.rowViews.append(self)
                }
            }
        }
    }
    
    var hasSeparators: Bool = true {
        didSet {
            reloadData()
        }
    }
    
    var viewsForRows: [NSView] = []
    var separatorViews: [NSBox] = []
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
    }
    
    func numberOfRows(inRowView rowView: RowView) -> Int {
        if delegate != nil {
            return delegate!.numberOfRows(inRowView: rowView)
        }
        
        return 0
    }
    
    func heightOf(row: Int, inRowView rowView: RowView) -> CGFloat {
        if delegate != nil {
            return delegate!.heightOf(row: row, inRowView: rowView)
        }
        
        return 30
    }
    
    func viewFor(row: Int, inRowView rowView: RowView) -> NSView? {
        if delegate != nil {
            return delegate!.viewFor(row: row, inRowView: rowView)
        }
        
        return nil
    }
    
    func shrinkHeightToRows() {
        var totalHeight: CGFloat = 0
        
        for row in 0 ..< self.numberOfRows(inRowView: self) {
            totalHeight += self.heightOf(row: row, inRowView: self)
        }
        
        frame.size.height = totalHeight
        
        positionRows()
    }
    
    internal func positionRows() {
        var currentTop: CGFloat = bounds.size.height
        
        for row in 0 ..< self.numberOfRows(inRowView: self) {
            let rowHeight: CGFloat = self.heightOf(row: row, inRowView: self)
            currentTop -= rowHeight
            
            viewsForRows[row].frame = CGRect(x: 0, y: currentTop, width: bounds.size.width, height: rowHeight)
            
            if hasSeparators {
                if row < self.numberOfRows(inRowView: self) - 1 {
                    separatorViews[row].frame = CGRect(x: 0, y: currentTop, width: bounds.size.width, height: 1)
                }
            }
        }
    }
    
    func reloadData() {
        while viewsForRows.count > 0 {
            viewsForRows.removeFirst().removeFromSuperview()
        }
        
        while separatorViews.count > 0 {
            separatorViews.removeFirst().removeFromSuperview()
        }
        
        for row in 0 ..< self.numberOfRows(inRowView: self) {
            let newView: NSView = self.viewFor(row: row, inRowView: self) ?? NSView()
            
            viewsForRows.append(newView)
            addSubview(newView)
        }
        
        if hasSeparators {
            if self.numberOfRows(inRowView: self) > 0 {
                for _ in 1 ..< self.numberOfRows(inRowView: self) {
                    let separator: NSBox = NSBox()
                    separator.boxType = NSBox.BoxType.separator
                    
                    separatorViews.append(separator)
                    addSubview(separator)
                }
            }
        }
        
        positionRows()
    }
    
}
