//
//  SetObjectPropertyBlock.swift
//  Mac Blocks
//
//  Created by Lucas Popp on 11/22/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import Cocoa

class SetObjectPropertyBlock: Block {
    
    override var blockDescription: String {
        get {
            return "Sets a specific property of an object."
        }
    }
    
    let input1: SlotInputComponent = SlotInputComponent(placeholder: "property", doubleClickData: TextInputBlock().dictionaryValue(), allowedInputTypes: DataType.string)
    let input2: SlotInputComponent = SlotInputComponent(placeholder: "value")
    let input3: SlotInputComponent = SlotInputComponent(placeholder: "object", allowedInputTypes: DataType.object)
    
    required init(origin: CGPoint = CGPoint.zero) {
        super.init(origin: origin)
        
        upperConnection.enabled = true
        lowerConnection.enabled = true
        
        let l1: BlockLine = BlockLine()
        
        l1.addComponents(TextComponent(text: "set"), input1, TextComponent(text: "to"), input2, TextComponent(text: "for"), input3)
        
        addLine(l1)
        
        fillColor = BlockColor.objectColor
        textColor = BlockColor.lightTextColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override func evaluate() -> Any? {
        if input1.input != nil && input2.input != nil && input3.input != nil {
            let propertyEvaluated: Any? = input1.input!.evaluate()
            
            if propertyEvaluated != nil && DataType.valueIsString(value: propertyEvaluated) {
                let itemValue: Any? = input2.input!.evaluate()
                let objectValue: DataObject? = DataType.valueAsObject(value: input3.input!.evaluate())
                
                if itemValue != nil && objectValue != nil {
                    objectValue!.object[DataType.valueAsString(value: propertyEvaluated!)!] = itemValue!
                }
            }
        } else {
            if input3.input == nil {
                workspace?.console.error(message: "Didn't provide an object to set the property of.", sourceBlock: self)
            }
            
            if input1.input == nil {
                workspace?.console.error(message: "Didn't define the property to set the value of.", sourceBlock: self)
            }
            
            if input2.input == nil {
                workspace?.console.error(message: "Didn't provide a value to set the property to.", sourceBlock: self)
            }
        }
        
        super.evaluate()
        
        return nil
    }
    
    override func duplicate() -> Block {
        return SetItemInListBlock()
    }
    
}
