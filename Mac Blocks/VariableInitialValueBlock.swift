//
//  VariableInitialValueBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 5/14/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Cocoa

class VariableInitialValueBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Creates a named variable, and immediately sets it to a value."
        }
    }
    
    let nameInput: SlotInputComponent = SlotInputComponent(placeholder: "name", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    let valueInput: SlotInputComponent = SlotInputComponent(placeholder: "value")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        l1.addComponents(TextComponent(text: "create a new variable named"), nameInput, TextComponent(text: "and set it to"), valueInput)
        
        addLine(l1)
        
        fillColor = BlockColor.variableColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if nameInput.input != nil && valueInput.input != nil {
            if let variableName: String = DataType.valueAsString(value: nameInput.input!.evaluate()) {
                let v: Variable = Variable(name: variableName)
                v.value = valueInput.input!.evaluate()
                
                workspace?.data.variables.append(v)
            }
        } else {
            if nameInput.input == nil {
                workspace?.console.error(message: "Didn't provide a name for the new variable.", sourceBlock: self)
            }
            
            if valueInput.input == nil {
                workspace?.console.error(message: "Didn't provide an initial value for the variable.", sourceBlock: self)
            }
        }
        
        return super.evaluate()
    }
    
    override func duplicate() -> Block {
        return VariableInitialValueBlock()
    }
    
}
