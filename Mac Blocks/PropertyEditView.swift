//
//  PropertyEditView.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/30/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class PropertyEditView: WorkspaceView {
    
    let propertyBlock: PropertyBlock = PropertyBlock(origin: CGPoint(x: WorkspaceView.PADDING, y: WorkspaceView.PADDING))
    
    override func unifiedInit() {
        super.unifiedInit()
        
        removeBlock(data.startBlock)
        
        addBlock(propertyBlock)
    }
    
}
