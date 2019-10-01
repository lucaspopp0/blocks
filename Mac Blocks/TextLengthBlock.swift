//
//  TextLengthBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class TextLengthBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs the length of a string of text."
        }
    }
    
    let slot: SlotInputComponent = SlotInputComponent(placeholder: "text", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.number
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "length of"), slot)
        
        addLine(l1)
        
        fillColor = BlockColor.textColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if slot.input != nil {
            let stringValue: String? = DataType.valueAsString(value: slot.input!.evaluate())
            
            if stringValue != nil {
                return stringValue!.characters.count
            }
        } else {
            workspace?.console.error(message: "Didn't specify the string to measure the length of.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return TextLengthBlock()
    }
    
}
