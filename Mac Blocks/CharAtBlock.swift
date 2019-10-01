//
//  CharAtBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class CharAtBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs the n-th letter from a string of text."
        }
    }
    
    let input1: SlotInputComponent = SlotInputComponent(placeholder: "n", doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let input2: SlotInputComponent = SlotInputComponent(placeholder: "string", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.string
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "get the character"), input1, TextComponent(text: "characters from the start of"), input2)
        
        addLine(l1)
        
        fillColor = BlockColor.textColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input1.input != nil && input2.input != nil {
            let indexEvaluated: Any? = input1.input!.evaluate()
            
            if indexEvaluated != nil && DataType.valueIsInt(value: indexEvaluated) {
                let indexValue: Int? = DataType.valueAsInt(value: input1.input!.evaluate())
                let stringValue: String? = DataType.valueAsString(value: input2.input!.evaluate())
                
                if indexValue! >= 0 && indexValue! < stringValue!.length {
                    return stringValue!.characterAt(index: indexValue!)
                }
            }
        } else {
            if input1.input == nil {
                workspace?.console.error(message: "Didn't specify which character to get.", sourceBlock: self)
            }
            
            if input2.input == nil {
                workspace?.console.error(message: "Didn't specify the string to search in.", sourceBlock: self)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return CharAtBlock()
    }
    
}
