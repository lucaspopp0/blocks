//
//  SplitStringBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/21/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class SplitStringBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Separates a string by a specific separator, and outputs a list of the pieces."
        }
    }
    
    let input1: SlotInputComponent = SlotInputComponent(placeholder: "string 1", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    let input2: SlotInputComponent = SlotInputComponent(placeholder: "string 2", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.list
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "list by separating"), input1, TextComponent(text: "by occurrances of"), input2)
        
        addLine(l1)
        
        fillColor = BlockColor.textColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input1.input != nil && input2.input != nil {
            let stringValue: String? = DataType.valueAsString(value: input1.input!.evaluate())
            let splitValue: String? = DataType.valueAsString(value: input2.input!.evaluate())
            
            if stringValue != nil && splitValue != nil {
                return DataList(items: stringValue!.components(separatedBy: splitValue!))
            }
        } else {
            if input1.input == nil {
                workspace?.console.error(message: "Didn't specify a string to separate.", sourceBlock: self)
            }
            
            if input2.input == nil {
                workspace?.console.error(message: "Didn't specify a string to separate by.", sourceBlock: self)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return SplitStringBlock()
    }
    
}
