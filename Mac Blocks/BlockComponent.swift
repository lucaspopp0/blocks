//
//  BlockComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/5/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The smallest piece of a block
class BlockComponent: InterfaceObject {
    
    enum Alignment {
        case left
        case right
    }
    
    var fullWidth: Bool = false
    var alignment = Alignment.left {
        didSet {
            layoutFullObjectHierarchy()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func extendFully(componentWidth: CGFloat) {
        frame.size.width = componentWidth
            
        redraw()
    }
    
}
