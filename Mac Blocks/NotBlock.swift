//
//  NotBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/8/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class NotBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs the inverse of a boolean value."
        }
    }
    
    let input: SlotInputComponent = SlotInputComponent(allowedInputTypes: DataType.boolean)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.boolean
        
        let l1: BlockLine = BlockLine()
        l1.addComponents(TextComponent(text: "not"), input)
        
        addLines(l1)
        
        fillColor = BlockColor.logicColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input.input != nil {
            let value: Bool? = DataType.valueAsBoolean(value: input.input!.evaluate())
            
            if value != nil {
                return !value!
            }
        } else {
            workspace?.console.error(message: "Must provide a boolean block to invert.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return NotBlock()
    }
    
}
