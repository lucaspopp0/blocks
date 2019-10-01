//
//  VariableGetterBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/11/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class VariableGetterBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Outputs the value of a variable."
        }
    }
    
    let nameInput: SlotInputComponent = SlotInputComponent(placeholder: "name", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        
        outputType = DataType.any
        
        l1.addComponents(TextComponent(text: "the value of"), nameInput)
        
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
                        return variable.value
                    }
                }
                
                workspace?.console.error(message: "No variable named \"\(variableName)\"", sourceBlock: self)
            }
        } else {
            workspace?.console.error(message: "Didn't provide a name for the variable to get the value of.", sourceBlock: self)
        }
        
        return nil
    }
    
    override func duplicate() -> Block {
        return VariableGetterBlock()
    }
    
}
