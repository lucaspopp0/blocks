//
//  StartBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/6/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// The entry point for the program
class StartBlock: Block {
    
    override var blockDescription: String {
        get {
            return "This is the first block that will be executed by the program."
        }
    }
    
    required init(origin: CGPoint = CGPoint(x: WorkspaceView.PADDING, y: WorkspaceView.PADDING)) {
        super.init(origin: origin)
        
        lowerConnection.enabled = true
        movable = false
        deletable = false
        
        let l1: BlockLine = BlockLine()
        l1.addComponent(TextComponent(text: "Start"))
        
        addLine(l1)
        
        fillColor = BlockColor.systemColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // No context menu on this block
    override func buildContextMenu() {
        super.buildContextMenu()
        
        for item: NSMenuItem in contextMenu.items {
            item.action = nil
        }
    }
    
    // No context menu on this block
    override func rightMouseDown(with event: NSEvent) {}
    
    override func duplicate() -> Block {
        return StartBlock()
    }
    
    @discardableResult override func evaluate() -> Any? {
        if let _: Block = lowerConnection.connectedTo as? Block {
            super.evaluate()
        } else {
            workspace?.console.warning(message: "No blocks connected to run!", sourceBlock: self)
        }
        
        return nil
    }
}
