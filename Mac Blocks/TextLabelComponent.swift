//
//  TextLabelComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/22/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Smaller label than TextLabelComponent
class TextLabelComponent: TextComponent {
    
    override init(text: String) {
        super.init(text: text)
        
        label.font = NSFont(name: Block.FONT.fontName, size: Block.FONT.pointSize * 0.75)
        label.textColor = NSColor.secondaryLabelColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateStyle() {
        super.updateStyle()
        
        label.font = NSFont(name: Block.FONT.fontName, size: Block.FONT.pointSize * 0.75)
        
        if container != nil && container!.container != nil && container!.container! is Block {
            label.textColor = NSColor.secondaryLabelColor
        }
    }
    
}
