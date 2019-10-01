//
//  ColorComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/2/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

// A circle that displays a specific color
class ColorComponent: BlockComponent {
    
    init(color: NSColor) {
        super.init()
        
        fillColor = color
        borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutObject() {
        frame.size.width = Block.PADDING * 3
        frame.size.height = Block.PADDING * 3
        
        borderLayer.path = CGPath(ellipseIn: bounds, transform: nil)
        styleLayer.path = CGPath(ellipseIn: bounds.insetBy(dx: borderWidth, dy: borderWidth), transform: nil)
        
        super.layoutObject()
    }
    
}
