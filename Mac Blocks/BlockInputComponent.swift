//
//  BlockInputComponent.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/6/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Generic component for inputting a block
class BlockInputComponent: BlockComponent {
    
    var input: Block?
    
    func connectInput(_ input: Block) {
        self.input = input
        input.inputAnchor = self
        
        if container != nil {
            if container!.container != nil && container!.container! is Block {
                (container!.container! as! Block).addInput(input)
            }
        }
        
        layoutFullObjectHierarchy()
    }
    
    func disconnectInput() {
        if input != nil {
            input!.inputAnchor = nil
            
            if container != nil {
                if container!.container != nil {
                    (container!.container! as! Block).removeInput(input!)
                }
            }
            
            input = nil
            
            layoutFullObjectHierarchy()
        }
    }
    
}
