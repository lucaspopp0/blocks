//
//  PrintBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

// Prints a value
class PrintBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Prints a value to the console below."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent(placeholder: "value", doubleClickData: TextInputBlock().dictionaryValue())
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "print"), slot)
        
        addLine(l1)
        
        fillColor = BlockColor.systemColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil {
            let inputValue: Any? = slot.input!.evaluate()
            
            if inputValue != nil {
                workspace?.console.print(inputValue!)
            } else {
                workspace?.console.error(message: "Could not print an empty value.", sourceBlock: self)
            }
        } else {
            workspace?.console.error(message: "No value specified to print.", sourceBlock: self)
        }
        
        super.evaluate()
        
        return nil
    }
    
    override func duplicate() -> Block {
        return PrintBlock()
    }
    
}
