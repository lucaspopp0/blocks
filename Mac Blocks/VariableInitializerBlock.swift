//
//  VariableInitializerBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/11/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class VariableInitializerBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Creates a named variable."
        }
    }
    
    let nameInput: SlotInputComponent = SlotInputComponent(placeholder: "name", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        let l1: BlockLine = BlockLine()
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        l1.addComponents(TextComponent(text: "create a new variable named"), nameInput)
        
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
                let v: Variable = Variable(name: variableName)
                
                workspace?.data.variables.append(v)
            }
        } else {
            workspace?.console.error(message: "Didn't provide a name for the new variable.", sourceBlock: self)
        }
        
        return super.evaluate()
    }
    
    override func duplicate() -> Block {
        return VariableInitializerBlock()
    }
    
}
