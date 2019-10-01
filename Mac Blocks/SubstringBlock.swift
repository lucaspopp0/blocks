//
//  SubstringBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/9/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class SubstringBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs a range of a string."
        }
    }
    
    let lowerBound: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let upperBound: SlotInputComponent = SlotInputComponent(doubleClickData: NumberInputBlock().dictionaryValue(), allowedInputTypes: DataType.number)
    let sourceString: SlotInputComponent = SlotInputComponent(placeholder: "text", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        outputType = DataType.string
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "get substring of"), sourceString, TextComponent(text: "from letter #"), lowerBound, TextComponent(text: "to letter #"), upperBound)
        
        addLine(l1)
        
        fillColor = BlockColor.textColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if lowerBound.input != nil && upperBound.input != nil && sourceString.input != nil {
            let lowerEvaluated: Any? = lowerBound.input!.evaluate()
            let upperEvaluated: Any? = upperBound.input!.evaluate()
            
            if DataType.valueIsInt(value: lowerEvaluated) && DataType.valueIsInt(value: upperEvaluated) {
                let lowerValue: Int = DataType.valueAsInt(value: lowerEvaluated)!
                let upperValue: Int = DataType.valueAsInt(value: upperEvaluated)!
                let str: String? = DataType.valueAsString(value: sourceString.input!.evaluate())
                
                if str != nil {
                    if lowerValue <= upperValue {
                        if lowerValue >= 0 {
                            if upperValue < str!.length {
                                return str!.substring(from: lowerValue, to: upperValue)
                            } else {
                                workspace?.console.error(message: "A substring cannot end after the end of a string.", sourceBlock: self)
                            }
                        } else {
                            workspace?.console.error(message: "A substring cannot start before the beginning of a string.", sourceBlock: self)
                        }
                    } else {
                        workspace?.console.error(message: "Cannot get a substring from letter #\(lowerValue) to letter #\(upperValue). The start of the substring must be before the end.", sourceBlock: self)
                    }
                }
            }
        } else {
            if lowerBound.input == nil {
                workspace?.console.error(message: "Didn't specify a letter # for the start of the substring.", sourceBlock: self)
            }
            
            if upperBound.input == nil {
                workspace?.console.error(message: "Didn't specify a letter # for the end of the substring.", sourceBlock: self)
            }
            
            if sourceString.input == nil {
                workspace?.console.error(message: "Didn't specify a string to take the substring of.", sourceBlock: self)
            }
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return SubstringBlock()
    }
    
}
