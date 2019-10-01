//
//  VariableSetterBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/11/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class VariableSetterBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Sets the value of a variable."
        }
    }
    
    let nameInput: SlotInputComponent = SlotInputComponent(placeholder: "name", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    let valueInput: SlotInputComponent = SlotInputComponent(placeholder: "value")
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        l1.addComponents(TextComponent(text: "set"), nameInput, TextComponent(text: "to"), valueInput)
        
        addLine(l1)
        
        fillColor = BlockColor.variableColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if nameInput.input != nil {
            if let variableName: String = DataType.valueAsString(value: nameInput.input!.evaluate()) {
                for variable: Variable in workspace!.data.variables {
                    if variable.name == variableName {
                        variable.value = valueInput.input?.evaluate()
                        break
                    }
                }
            }
        } else {
            workspace?.console.error(message: "Didn't provide the name of the variable to set the value of.", sourceBlock: self)
        }
        
        return super.evaluate()
    }
    
    override func duplicate() -> Block {
        return VariableSetterBlock()
    }
    
}
