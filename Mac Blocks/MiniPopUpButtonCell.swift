//
//  MiniPopUpButtonCell.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/24/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// NSPopUpButtonCell with a custom appearance
class MiniPopUpButtonCell: NSPopUpButtonCell {
    
    var textColor: NSColor = NSColor.white {
        didSet {
            selectItem(at: indexOfSelectedItem)
        }
    }
    
    override func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
        let mutableTitle: NSMutableAttributedString = title.mutableCopy() as! NSMutableAttributedString
        
        mutableTitle.addAttributes([
            NSAttributedStringKey.foregroundColor : NSColor.clear,
            NSAttributedStringKey.font : Block.FONT
            ], range: NSRange(location: 0, length: mutableTitle.length))
        
        return super.drawTitle(mutableTitle, withFrame: frame, in: controlView)
    }
    
    override func titleRect(forBounds cellFrame: NSRect) -> NSRect {
        var output: CGRect = super.titleRect(forBounds: cellFrame)
        
        output.origin.x = 0
        
        return output
    }
    
}
