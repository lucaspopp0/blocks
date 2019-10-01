//
//  TextComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The equivalent of a label
class TextComponent: BlockComponent {
    
    let label: NSTextField = NSTextField()
    
    init(text: String) {
        super.init()
        
        label.isEditable = false
        label.isBordered = false
        label.isSelectable = false
        label.backgroundColor = NSColor.clear
        label.font = Block.FONT
        
        addSubview(label)
        
        label.stringValue = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateStyle() {
        super.updateStyle()
        
        label.font = Block.FONT
        
        if container != nil && container!.container != nil && container!.container! is Block {
            label.textColor = (container!.container as! Block).textColor
        }
    }
    
    override func layoutObject() {
        label.sizeToFit()
        
        let labelSize: CGSize = label.stringValue.size(withAttributes: [NSAttributedStringKey.font: label.font!])
        
        let dw: CGFloat = label.frame.size.width  - labelSize.width
        
        label.frame.origin.x = -dw / 2
        label.frame.origin.y = 1.5
        
        frame.size = labelSize
        
        super.layoutObject()
    }
    
}
