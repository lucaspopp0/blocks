//
//  WorkspaceData.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Data representing a workspace
class WorkspaceData {
    
    var blocks: [Block]
    var variables: [Variable] = []
    var startBlock: StartBlock
    
    // Windows created in the execution have to be stored here, otherwise they close as soon as the system deallocates them
    var windowReferences: [NSWindowController] = []
    
    init() {
        startBlock = StartBlock(origin: CGPoint(x: WorkspaceView.PADDING, y: WorkspaceView.PADDING))
        blocks = []
    }
    
    init?(blocks: [Block]) {
        var startBlockFound: Bool = false
        var startBlock: StartBlock = StartBlock()
        
        for block: Block in blocks {
            if block is StartBlock {
                startBlockFound = true
                startBlock = block as! StartBlock
                break
            }
        }
        
        if !startBlockFound {
            return nil
        } else {
            self.blocks = blocks
            self.startBlock = startBlock
        }
    }
    
    func run() {
        windowReferences.removeAll()
        variables.removeAll()
        startBlock.evaluate()
    }
    
}
