//
//  ChunkInputLine.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/8/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// A BlockLine containing only a ChunkInputComponent
class ChunkInputLine: BlockLine {
    
    let component: ChunkInputComponent = ChunkInputComponent()
    
    override init() {
        super.init()
        
        fullWidth = true
        
        addComponent(component)
    }
    
    convenience init(placeholder: String) {
        self.init()
        
        component.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func extendFully(lineWidth: CGFloat) {
        if component.anchor.connectedTo == nil {
            frame.size.width = lineWidth
            component.extendFully(componentWidth: lineWidth)
        }
    }
    
}
